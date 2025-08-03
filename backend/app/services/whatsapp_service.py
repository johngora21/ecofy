import os
import httpx
import logging
from typing import Optional, Dict, Any, List, Tuple
from datetime import datetime
from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.services.openai_service import openai_service
from app.services.voice_training_service import voice_training_service
from app.models.whatsapp import WhatsAppTemplate, WhatsAppMessage, WhatsAppSession, WhatsAppWebhook
from app.models.user import User

logger = logging.getLogger(__name__)

class WhatsAppService:
    def __init__(self):
        # Beem Africa API credentials - these should be in environment variables
        self.api_key = os.getenv("BEEM_API_KEY", "your_beem_api_key")
        self.secret_key = os.getenv("BEEM_SECRET_KEY", "your_beem_secret_key")
        self.base_url = "https://apichatcore.beem.africa/v1"
        self.broadcast_url = "https://apibroadcast.beem.africa/v1"
        self.headers = {
            "Content-Type": "application/json"
        }
        
    def _get_auth_headers(self):
        """Get authentication headers for Beem API"""
        return {
            "api_key": self.api_key,
            "secret_key": self.secret_key,
            "Content-Type": "application/json"
        }

    async def fetch_templates(self, name: str = None, category: str = None, 
                            status: str = None, page: int = 1) -> Dict[str, Any]:
        """Fetch WhatsApp templates from Beem API"""
        try:
            params = {"page": page}
            if name:
                params["name"] = name
            if category:
                params["category"] = category
            if status:
                params["status"] = status
                
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(
                    f"{self.base_url}/message-templates/list",
                    headers=self._get_auth_headers(),
                    params=params
                )
                
                if response.status_code == 200:
                    return response.json()
                else:
                    logger.error(f"Template fetch error: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Failed to fetch templates")
                    
        except Exception as e:
            logger.error(f"Error fetching templates: {e}")
            raise HTTPException(status_code=500, detail=f"Template fetch error: {str(e)}")

    async def send_template_message(self, from_addr: str, destination_addr: List[Dict], 
                                  template_id: str, content: Dict = None) -> Dict[str, Any]:
        """Send template-based WhatsApp message"""
        try:
            payload = {
                "from_addr": from_addr,
                "destination_addr": destination_addr,
                "channel": "whatsapp",
                "messageTemplateData": {
                    "id": template_id
                }
            }
            
            if content:
                payload["content"] = content
                
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    f"{self.broadcast_url}/broadcast/template/api-send",
                    headers=self._get_auth_headers(),
                    json=payload
                )
                
                if response.status_code == 200:
                    return response.json()
                else:
                    logger.error(f"Template send error: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Failed to send template message")
                    
        except Exception as e:
            logger.error(f"Error sending template message: {e}")
            raise HTTPException(status_code=500, detail=f"Template send error: {str(e)}")

    async def get_or_create_session(self, phone_number: str, user_id: str, db: Session) -> WhatsAppSession:
        """Get existing WhatsApp session or create new one"""
        try:
            # Check for existing active session
            session = db.query(WhatsAppSession).filter(
                WhatsAppSession.phone_number == phone_number,
                WhatsAppSession.session_status == "active"
            ).first()
            
            if not session:
                # Create new session
                session = WhatsAppSession(
                    user_id=user_id,
                    phone_number=phone_number,
                    session_status="active",
                    conversation_context={}
                )
                db.add(session)
                db.commit()
                db.refresh(session)
                logger.info(f"Created new WhatsApp session for {phone_number}")
            
            return session
            
        except Exception as e:
            logger.error(f"Error managing WhatsApp session: {e}")
            db.rollback()
            raise HTTPException(status_code=500, detail="Session management error")

    async def process_incoming_message(self, phone_number: str, message: str, 
                                     message_type: str = "text", media_url: str = None,
                                     db: Session = None) -> Tuple[str, str, Optional[bytes]]:
        """Process incoming WhatsApp message and generate AI response"""
        try:
            # Find or create user based on phone number
            user = db.query(User).filter(User.phone == phone_number).first()
            if not user:
                # Create a basic user profile for WhatsApp users
                user = User(
                    phone=phone_number,
                    full_name=f"WhatsApp User {phone_number}",
                    role="farmer",  # Default role
                    is_verified=False
                )
                db.add(user)
                db.commit()
                db.refresh(user)
                logger.info(f"Created new user for WhatsApp number: {phone_number}")
            
            # Get or create session
            session = await self.get_or_create_session(phone_number, user.id, db)
            
            # Update session context
            if not session.conversation_context:
                session.conversation_context = {"messages": []}
            
            session.conversation_context["messages"].append({
                "timestamp": datetime.utcnow().isoformat(),
                "type": message_type,
                "content": message,
                "media_url": media_url
            })
            session.last_message_time = datetime.utcnow()
            
            # Process based on message type
            if message_type == "text":
                # Generate text response
                ai_response = await openai_service.generate_text_response(message, user, db)
                response_type = "text"
                audio_data = None
                
            elif message_type == "voice":
                # Process voice message - download audio first
                if media_url:
                    audio_bytes = await self._download_media(media_url)
                    ai_response, audio_data = await openai_service.process_voice_message(audio_bytes, user, db)
                    response_type = "voice"
                    
                    # CONTINUOUS LEARNING: Train from farmer voice
                    transcribed_text = await openai_service.transcribe_audio(audio_bytes)
                    training_result = await voice_training_service.process_farmer_voice_for_training(
                        audio_bytes, transcribed_text, ai_response, user, db
                    )
                    logger.info(f"Voice training result: {training_result}")
                    
                else:
                    ai_response = "Sorry, I couldn't process your voice message."
                    response_type = "text"
                    audio_data = None
                    
            elif message_type == "image":
                # Process image message
                if media_url:
                    image_bytes = await self._download_media(media_url)
                    ai_response = await openai_service.analyze_crop_image(image_bytes, message, user, db)
                    response_type = "text"
                    audio_data = None
                else:
                    ai_response = "Sorry, I couldn't process your image."
                    response_type = "text"
                    audio_data = None
            else:
                ai_response = "I can help you with text messages, voice notes, and crop images. How can I assist you with your farming today?"
                response_type = "text"
                audio_data = None
            
            # Add AI response to context
            session.conversation_context["messages"].append({
                "timestamp": datetime.utcnow().isoformat(),
                "type": response_type,
                "content": ai_response,
                "is_ai": True
            })
            
            db.add(session)
            db.commit()
            
            return ai_response, response_type, audio_data
            
        except Exception as e:
            logger.error(f"Error processing WhatsApp message: {e}")
            db.rollback()
            return "Sorry, I'm having trouble processing your message right now. Please try again.", "text", None

    async def _download_media(self, media_url: str) -> bytes:
        """Download media from WhatsApp"""
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(media_url)
                if response.status_code == 200:
                    return response.content
                else:
                    raise HTTPException(status_code=400, detail="Failed to download media")
        except Exception as e:
            logger.error(f"Error downloading media: {e}")
            raise HTTPException(status_code=500, detail="Media download error")

    async def send_text_response(self, phone_number: str, message: str, from_addr: str) -> bool:
        """Send text response via WhatsApp (if Beem supports direct messaging)"""
        try:
            # Note: This depends on Beem's direct messaging capabilities
            # You might need to use templates instead
            payload = {
                "from_addr": from_addr,
                "destination_addr": phone_number,
                "message": message,
                "channel": "whatsapp"
            }
            
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    f"{self.base_url}/chat-send",
                    headers=self._get_auth_headers(),
                    json=payload
                )
                
                return response.status_code == 200
                
        except Exception as e:
            logger.error(f"Error sending WhatsApp response: {e}")
            return False

    async def send_voice_response(self, phone_number: str, audio_data: bytes, from_addr: str) -> bool:
        """Send voice response via WhatsApp"""
        try:
            # You'll need to upload the audio to a accessible URL first
            # Then send as media message
            # This is a simplified version - implement based on Beem's media API
            
            # For now, convert to text and send
            # In production, upload audio to your server/cloud storage
            logger.info(f"Voice response generated for {phone_number} ({len(audio_data)} bytes)")
            return True
            
        except Exception as e:
            logger.error(f"Error sending voice response: {e}")
            return False

    async def handle_webhook(self, webhook_data: Dict[str, Any], db: Session) -> bool:
        """Handle incoming WhatsApp webhook"""
        try:
            # Store webhook data
            webhook = WhatsAppWebhook(
                broadcast_id=webhook_data.get("broadcast_id"),
                message_id=webhook_data.get("message_id"),
                status=webhook_data.get("status"),
                destination=webhook_data.get("destination"),
                message=webhook_data.get("message"),
                timestamp=datetime.fromisoformat(webhook_data.get("timestamp", datetime.utcnow().isoformat())),
                raw_data=webhook_data
            )
            
            db.add(webhook)
            db.commit()
            
            # Process incoming message if it's a new message
            if webhook_data.get("status") == "received":
                phone_number = webhook_data.get("destination")
                message = webhook_data.get("message", "")
                
                # Determine message type from webhook data
                message_type = "text"  # Default
                media_url = None
                
                if "media" in webhook_data:
                    if "audio" in webhook_data["media"]:
                        message_type = "voice"
                        media_url = webhook_data["media"]["audio"]["url"]
                    elif "image" in webhook_data["media"]:
                        message_type = "image"
                        media_url = webhook_data["media"]["image"]["url"]
                
                # Process the message
                ai_response, response_type, audio_data = await self.process_incoming_message(
                    phone_number, message, message_type, media_url, db
                )
                
                # Send response back
                from_addr = os.getenv("WHATSAPP_FROM_NUMBER", "your_whatsapp_number")
                
                if response_type == "voice" and audio_data:
                    await self.send_voice_response(phone_number, audio_data, from_addr)
                else:
                    await self.send_text_response(phone_number, ai_response, from_addr)
            
            return True
            
        except Exception as e:
            logger.error(f"Error handling webhook: {e}")
            db.rollback()
            return False

    async def send_farming_alert(self, user_phone: str, alert_message: str, template_id: str = None) -> bool:
        """Send farming alerts/notifications via WhatsApp"""
        try:
            from_addr = os.getenv("WHATSAPP_FROM_NUMBER", "your_whatsapp_number")
            
            if template_id:
                # Use template for official notifications
                destination_addr = [{"phoneNumber": user_phone, "params": [alert_message]}]
                result = await self.send_template_message(from_addr, destination_addr, template_id)
                return result.get("statusCode") == "200"
            else:
                # Send as regular message
                return await self.send_text_response(user_phone, alert_message, from_addr)
                
        except Exception as e:
            logger.error(f"Error sending farming alert: {e}")
            return False

# Global instance
whatsapp_service = WhatsAppService() 