from fastapi import APIRouter, Depends, HTTPException, status, Request, Body
from typing import List, Dict, Any
import logging
from bson import ObjectId
from datetime import datetime

from app.api.deps import get_current_user
from app.database import get_database
from app.schemas.whatsapp import (
    WhatsAppTemplate as WhatsAppTemplateSchema,
    WhatsAppTemplateCreate,
    WhatsAppMessage as WhatsAppMessageSchema,
    WhatsAppMessageCreate,
    WhatsAppSession as WhatsAppSessionSchema,
    WhatsAppSessionCreate,
    WhatsAppWebhook as WhatsAppWebhookSchema,
    TemplateListRequest,
    TemplateSendRequest,
    WebhookCallbackRequest,
    WhatsAppAIMessage,
    WhatsAppAIResponse
)
from app.services.whatsapp_service import whatsapp_service

router = APIRouter()
logger = logging.getLogger(__name__)

# Template Management Routes
@router.get("/templates", response_model=Dict[str, Any])
async def list_templates(
    name: str = None,
    category: str = None,
    status: str = None,
    page: int = 1,
    current_user: dict = Depends(get_current_user)
):
    """Fetch WhatsApp templates from Beem API"""
    try:
        return await whatsapp_service.fetch_templates(name, category, status, page)
    except Exception as e:
        logger.error(f"Error fetching templates: {e}")
        raise HTTPException(status_code=500, detail="Failed to fetch templates")

@router.post("/templates/send", response_model=Dict[str, Any])
async def send_template_message(
    request: TemplateSendRequest,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Send template-based WhatsApp message"""
    try:
        result = await whatsapp_service.send_template_message(
            request.from_addr,
            request.destination_addr,
            str(request.messageTemplateData["id"]),
            request.content
        )
        
        # Store message record in database
        for dest in request.destination_addr:
            phone_number = dest["phoneNumber"]
            params = dest.get("params", [])
            
            message_doc = {
                "from_addr": request.from_addr,
                "destination_addr": phone_number,
                "message_type": "template",
                "template_id": str(request.messageTemplateData["id"]),
                "params": params,
                "status": "sent",
                "job_id": result.get("jobId"),
                "created_at": datetime.utcnow()
            }
            db.whatsapp_messages.insert_one(message_doc)
        
        return result
        
    except Exception as e:
        logger.error(f"Error sending template message: {e}")
        raise HTTPException(status_code=500, detail="Failed to send template message")

# AI Chat Routes
@router.post("/ai/chat", response_model=WhatsAppAIResponse)
async def ai_chat_message(
    request: WhatsAppAIMessage,
    db = Depends(get_database)
):
    """Process AI chat message via WhatsApp"""
    try:
        ai_response, response_type, audio_data = await whatsapp_service.process_incoming_message(
            phone_number=request.phone_number,
            message=request.message,
            message_type="text",
            db=db
        )
        
        return WhatsAppAIResponse(
            message=ai_response,
            response_type=response_type,
            audio_data=audio_data
        )
        
    except Exception as e:
        logger.error(f"Error processing AI chat: {e}")
        raise HTTPException(status_code=500, detail="Failed to process AI chat")

@router.post("/ai/voice", response_model=WhatsAppAIResponse)
async def ai_voice_message(
    phone_number: str = Body(...),
    voice_url: str = Body(...),
    db = Depends(get_database)
):
    """Process AI voice message via WhatsApp"""
    try:
        ai_response, response_type, audio_data = await whatsapp_service.process_incoming_message(
            phone_number=phone_number,
            message="",  # Voice message
            message_type="voice",
            voice_url=voice_url,
            db=db
        )
        
        return WhatsAppAIResponse(
            message=ai_response,
            response_type=response_type,
            audio_data=audio_data
        )
        
    except Exception as e:
        logger.error(f"Error processing AI voice: {e}")
        raise HTTPException(status_code=500, detail="Failed to process AI voice")

@router.post("/ai/image", response_model=WhatsAppAIResponse)
async def ai_image_analysis(
    phone_number: str = Body(...),
    image_url: str = Body(...),
    message: str = Body("Please analyze this crop image"),
    db = Depends(get_database)
):
    """Process AI image analysis via WhatsApp"""
    try:
        ai_response, response_type, audio_data = await whatsapp_service.process_incoming_message(
            phone_number=phone_number,
            message=message,
            message_type="image",
            image_url=image_url,
            db=db
        )
        
        return WhatsAppAIResponse(
            message=ai_response,
            response_type=response_type,
            audio_data=audio_data
        )
        
    except Exception as e:
        logger.error(f"Error processing AI image: {e}")
        raise HTTPException(status_code=500, detail="Failed to process AI image")

# Session Management Routes
@router.get("/sessions", response_model=List[WhatsAppSessionSchema])
async def get_whatsapp_sessions(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get WhatsApp sessions for current user"""
    sessions = list(db.whatsapp_sessions.find({"user_id": current_user["_id"]}).sort("last_message_time", -1))
    return sessions

@router.get("/sessions/{session_id}", response_model=WhatsAppSessionSchema)
async def get_whatsapp_session(
    session_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get specific WhatsApp session"""
    session = db.whatsapp_sessions.find_one({
        "_id": ObjectId(session_id),
        "user_id": current_user["_id"]
    })
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="WhatsApp session not found"
        )
    
    return session

# Webhook Routes
@router.post("/webhook", response_model=Dict[str, str])
async def whatsapp_webhook(
    request: Request,
    db = Depends(get_database)
):
    """Handle WhatsApp webhook from Beem Africa"""
    try:
        webhook_data = await request.json()
        logger.info(f"Received WhatsApp webhook: {webhook_data}")
        
        success = await whatsapp_service.handle_webhook(webhook_data, db)
        
        if success:
            return {"status": "success", "message": "Webhook processed"}
        else:
            raise HTTPException(status_code=500, detail="Webhook processing failed")
            
    except Exception as e:
        logger.error(f"Webhook error: {e}")
        raise HTTPException(status_code=500, detail="Webhook processing error")

@router.get("/webhook")
async def webhook_verification(request: Request):
    """Webhook verification endpoint for Beem Africa"""
    # Beem might require GET endpoint verification
    return {"status": "active", "message": "WhatsApp webhook is active"}

# Message Management Routes
@router.get("/messages", response_model=List[WhatsAppMessageSchema])
async def get_whatsapp_messages(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get WhatsApp messages for current user"""
    messages = list(db.whatsapp_messages.find({"user_id": current_user["_id"]}).sort("created_at", -1).limit(50))
    return messages

@router.post("/messages/send", response_model=WhatsAppMessageSchema)
async def send_whatsapp_message(
    message_data: WhatsAppMessageCreate,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Send WhatsApp message"""
    try:
        # Create message record
        message_doc = {
            "user_id": current_user["_id"],
            **message_data.dict(),
            "created_at": datetime.utcnow()
        }
        
        result = db.whatsapp_messages.insert_one(message_doc)
        message_doc["_id"] = result.inserted_id
        
        # Send via WhatsApp service
        success = await whatsapp_service.send_text_response(
            message_data.destination_addr,
            message_data.content or "Message from EcoFy",
            message_data.from_addr
        )
        
        if success:
            db.whatsapp_messages.update_one(
                {"_id": result.inserted_id},
                {"$set": {"status": "sent"}}
            )
        else:
            db.whatsapp_messages.update_one(
                {"_id": result.inserted_id},
                {"$set": {"status": "failed", "error_message": "Failed to send message"}}
            )
        
        return message_doc
        
    except Exception as e:
        logger.error(f"Error sending message: {e}")
        raise HTTPException(status_code=500, detail="Failed to send message")

# Webhook Data Routes
@router.get("/webhooks", response_model=List[WhatsAppWebhookSchema])
async def get_webhook_data(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get webhook delivery data"""
    webhooks = list(db.whatsapp_webhooks.find().sort("created_at", -1).limit(100))
    return webhooks

# Utility Routes
@router.post("/alerts/send")
async def send_farming_alert(
    phone_number: str = Body(...),
    alert_message: str = Body(...),
    template_id: str = Body(None),
    current_user: dict = Depends(get_current_user)
):
    """Send farming alert to farmer via WhatsApp"""
    try:
        success = await whatsapp_service.send_farming_alert(
            phone_number, alert_message, template_id
        )
        
        if success:
            return {"status": "success", "message": "Alert sent successfully"}
        else:
            raise HTTPException(status_code=500, detail="Failed to send alert")
            
    except Exception as e:
        logger.error(f"Error sending farming alert: {e}")
        raise HTTPException(status_code=500, detail="Failed to send farming alert")

@router.get("/test/ai")
async def test_ai_integration(
    message: str = "What crops should I plant this season?",
    db = Depends(get_database)
):
    """Test AI integration"""
    try:
        ai_response, response_type, audio_data = await whatsapp_service.process_incoming_message(
            phone_number="+255123456789",
            message=message,
            message_type="text",
            db=db
        )
        
        return {
            "message": ai_response,
            "response_type": response_type,
            "audio_data": audio_data
        }
        
    except Exception as e:
        logger.error(f"Error testing AI: {e}")
        raise HTTPException(status_code=500, detail="Failed to test AI integration") 