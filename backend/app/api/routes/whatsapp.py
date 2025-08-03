from fastapi import APIRouter, Depends, HTTPException, status, Request, Body
from sqlalchemy.orm import Session
from typing import List, Dict, Any
import logging

from app.api.deps import get_current_user
from app.database import get_db
from app.models.user import User
from app.models.whatsapp import WhatsAppTemplate, WhatsAppMessage, WhatsAppSession, WhatsAppWebhook
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
    current_user: User = Depends(get_current_user)
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
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
            
            message = WhatsAppMessage(
                from_addr=request.from_addr,
                destination_addr=phone_number,
                message_type="template",
                template_id=str(request.messageTemplateData["id"]),
                params=params,
                status="sent",
                job_id=result.get("jobId")
            )
            db.add(message)
        
        db.commit()
        return result
        
    except Exception as e:
        logger.error(f"Error sending template message: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to send template message")

# AI Chat Routes
@router.post("/ai/chat", response_model=WhatsAppAIResponse)
async def ai_chat_message(
    request: WhatsAppAIMessage,
    db: Session = Depends(get_db)
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
            template_id=None,
            params=None,
            media_url=None
        )
        
    except Exception as e:
        logger.error(f"Error processing AI chat: {e}")
        raise HTTPException(status_code=500, detail="Failed to process AI chat")

@router.post("/ai/voice", response_model=WhatsAppAIResponse)
async def ai_voice_message(
    phone_number: str = Body(...),
    voice_url: str = Body(...),
    db: Session = Depends(get_db)
):
    """Process AI voice message via WhatsApp"""
    try:
        ai_response, response_type, audio_data = await whatsapp_service.process_incoming_message(
            phone_number=phone_number,
            message="[Voice message]",
            message_type="voice",
            media_url=voice_url,
            db=db
        )
        
        # In production, you'd upload audio_data to accessible URL
        media_url = None
        if audio_data:
            # TODO: Upload audio_data to cloud storage and get URL
            media_url = "https://your-server.com/audio/response.mp3"
        
        return WhatsAppAIResponse(
            message=ai_response,
            template_id=None,
            params=None,
            media_url=media_url
        )
        
    except Exception as e:
        logger.error(f"Error processing AI voice: {e}")
        raise HTTPException(status_code=500, detail="Failed to process AI voice")

@router.post("/ai/image", response_model=WhatsAppAIResponse)
async def ai_image_analysis(
    phone_number: str = Body(...),
    image_url: str = Body(...),
    message: str = Body("Please analyze this crop image"),
    db: Session = Depends(get_db)
):
    """Process AI image analysis via WhatsApp"""
    try:
        ai_response, response_type, audio_data = await whatsapp_service.process_incoming_message(
            phone_number=phone_number,
            message=message,
            message_type="image",
            media_url=image_url,
            db=db
        )
        
        return WhatsAppAIResponse(
            message=ai_response,
            template_id=None,
            params=None,
            media_url=None
        )
        
    except Exception as e:
        logger.error(f"Error processing AI image: {e}")
        raise HTTPException(status_code=500, detail="Failed to process AI image")

# Session Management Routes
@router.get("/sessions", response_model=List[WhatsAppSessionSchema])
async def get_whatsapp_sessions(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get WhatsApp sessions for current user"""
    sessions = db.query(WhatsAppSession).filter(
        WhatsAppSession.user_id == current_user.id
    ).order_by(WhatsAppSession.last_message_time.desc()).all()
    
    return sessions

@router.get("/sessions/{session_id}", response_model=WhatsAppSessionSchema)
async def get_whatsapp_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get specific WhatsApp session"""
    session = db.query(WhatsAppSession).filter(
        WhatsAppSession.id == session_id,
        WhatsAppSession.user_id == current_user.id
    ).first()
    
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
    db: Session = Depends(get_db)
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get WhatsApp messages for current user"""
    messages = db.query(WhatsAppMessage).filter(
        WhatsAppMessage.user_id == current_user.id
    ).order_by(WhatsAppMessage.created_at.desc()).limit(50).all()
    
    return messages

@router.post("/messages/send", response_model=WhatsAppMessageSchema)
async def send_whatsapp_message(
    message_data: WhatsAppMessageCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Send WhatsApp message"""
    try:
        # Create message record
        message = WhatsAppMessage(
            user_id=current_user.id,
            **message_data.dict()
        )
        
        db.add(message)
        db.commit()
        db.refresh(message)
        
        # Send via WhatsApp service
        success = await whatsapp_service.send_text_response(
            message_data.destination_addr,
            message_data.content or "Message from EcoFy",
            message_data.from_addr
        )
        
        if success:
            message.status = "sent"
        else:
            message.status = "failed"
            message.error_message = "Failed to send message"
        
        db.add(message)
        db.commit()
        
        return message
        
    except Exception as e:
        logger.error(f"Error sending message: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to send message")

# Webhook Data Routes
@router.get("/webhooks", response_model=List[WhatsAppWebhookSchema])
async def get_webhook_data(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get webhook delivery data"""
    webhooks = db.query(WhatsAppWebhook).order_by(
        WhatsAppWebhook.created_at.desc()
    ).limit(100).all()
    
    return webhooks

# Utility Routes
@router.post("/alerts/send")
async def send_farming_alert(
    phone_number: str = Body(...),
    alert_message: str = Body(...),
    template_id: str = Body(None),
    current_user: User = Depends(get_current_user)
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
    db: Session = Depends(get_db)
):
    """Test AI integration (development only)"""
    try:
        from app.services.openai_service import openai_service
        
        response = await openai_service.generate_text_response(message)
        return {"message": message, "ai_response": response}
        
    except Exception as e:
        logger.error(f"AI test error: {e}")
        raise HTTPException(status_code=500, detail="AI test failed") 