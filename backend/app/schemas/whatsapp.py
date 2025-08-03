from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from enum import Enum

class TemplateCategory(str, Enum):
    AUTHENTICATION = "AUTHENTICATION"
    UTILITY = "UTILITY"
    MARKETING = "MARKETING"

class TemplateType(str, Enum):
    TEXT = "TEXT"
    IMAGE = "IMAGE"
    VIDEO = "VIDEO"
    DOCUMENT = "DOCUMENT"

class TemplateStatus(str, Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"
    FAILED = "failed"

class MessageStatus(str, Enum):
    PENDING = "pending"
    SENT = "sent"
    DELIVERED = "delivered"
    READ = "read"
    FAILED = "failed"

class WhatsAppTemplateBase(BaseModel):
    name: str = Field(..., description="Template name")
    category: TemplateCategory = Field(..., description="Template category")
    type: TemplateType = Field(..., description="Template type")
    language: str = Field(default="en_US", description="Template language")
    content: str = Field(..., description="Template content")
    media_url: Optional[str] = Field(None, description="Media URL if applicable")
    mime_type: Optional[str] = Field(None, description="MIME type for media")
    buttons: Optional[List[Dict[str, Any]]] = Field(None, description="Template buttons")
    footer: Optional[str] = Field(None, description="Template footer")
    header: Optional[str] = Field(None, description="Template header")

class WhatsAppTemplateCreate(WhatsAppTemplateBase):
    bot_id: str = Field(..., description="Bot ID for the template")

class WhatsAppTemplateUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[TemplateCategory] = None
    type: Optional[TemplateType] = None
    language: Optional[str] = None
    content: Optional[str] = None
    media_url: Optional[str] = None
    mime_type: Optional[str] = None
    buttons: Optional[List[Dict[str, Any]]] = None
    footer: Optional[str] = None
    header: Optional[str] = None
    status: Optional[TemplateStatus] = None

class WhatsAppTemplate(WhatsAppTemplateBase):
    id: str
    template_id: str
    facebook_template_id: Optional[str] = None
    status: TemplateStatus
    bot_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class WhatsAppMessageBase(BaseModel):
    from_addr: str = Field(..., description="Sender WhatsApp number")
    destination_addr: str = Field(..., description="Receiver WhatsApp number")
    message_type: str = Field(..., description="Message type")
    content: Optional[str] = Field(None, description="Message content")
    media_url: Optional[str] = Field(None, description="Media URL")
    params: Optional[List[Dict[str, Any]]] = Field(None, description="Template parameters")

class WhatsAppMessageCreate(WhatsAppMessageBase):
    user_id: Optional[str] = Field(None, description="User ID if sending to a registered user")
    template_id: Optional[str] = Field(None, description="Template ID if using a template")

class WhatsAppMessageUpdate(BaseModel):
    status: Optional[MessageStatus] = None
    job_id: Optional[str] = None
    message_id: Optional[str] = None
    error_message: Optional[str] = None

class WhatsAppMessage(WhatsAppMessageBase):
    id: str
    user_id: Optional[str] = None
    template_id: Optional[str] = None
    status: MessageStatus
    job_id: Optional[str] = None
    message_id: Optional[str] = None
    error_message: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class WhatsAppWebhookBase(BaseModel):
    broadcast_id: Optional[str] = Field(None, description="Broadcast ID")
    message_id: Optional[str] = Field(None, description="Message ID")
    status: str = Field(..., description="Message status")
    destination: str = Field(..., description="Destination phone number")
    message: Optional[str] = Field(None, description="Message content")
    timestamp: Optional[datetime] = Field(None, description="Timestamp")
    raw_data: Optional[Dict[str, Any]] = Field(None, description="Raw webhook data")

class WhatsAppWebhookCreate(WhatsAppWebhookBase):
    pass

class WhatsAppWebhook(WhatsAppWebhookBase):
    id: str
    processed: bool
    created_at: datetime

    class Config:
        from_attributes = True

class WhatsAppSessionBase(BaseModel):
    phone_number: str = Field(..., description="WhatsApp phone number")
    session_status: str = Field(default="active", description="Session status")
    conversation_context: Optional[Dict[str, Any]] = Field(None, description="Conversation context")

class WhatsAppSessionCreate(WhatsAppSessionBase):
    user_id: str = Field(..., description="User ID")

class WhatsAppSessionUpdate(BaseModel):
    session_status: Optional[str] = None
    last_message_time: Optional[datetime] = None
    conversation_context: Optional[Dict[str, Any]] = None

class WhatsAppSession(WhatsAppSessionBase):
    id: str
    user_id: str
    last_message_time: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# API Request/Response Models
class TemplateListRequest(BaseModel):
    name: Optional[str] = None
    category: Optional[TemplateCategory] = None
    q: Optional[str] = None
    status: Optional[TemplateStatus] = None
    page: Optional[int] = Field(default=1, ge=1)

class TemplateSendRequest(BaseModel):
    from_addr: str = Field(..., description="Sender WhatsApp number")
    destination_addr: List[Dict[str, Any]] = Field(..., description="List of destinations with parameters")
    channel: str = Field(default="whatsapp", description="Messaging channel")
    content: Optional[Dict[str, Any]] = Field(None, description="Message metadata")
    messageTemplateData: Dict[str, Any] = Field(..., description="Template data")

class TemplateSendResponse(BaseModel):
    statusCode: str
    message: str
    validation: Dict[str, Any]
    credits: Dict[str, Any]
    jobId: str

class WebhookCallbackRequest(BaseModel):
    broadcast_id: Optional[str] = None
    message_id: Optional[str] = None
    status: str
    destination: str
    message: Optional[str] = None
    timestamp: Optional[str] = None

# AI Chat Models for WhatsApp
class WhatsAppAIMessage(BaseModel):
    phone_number: str = Field(..., description="WhatsApp phone number")
    message: str = Field(..., description="User message")
    session_id: Optional[str] = Field(None, description="Session ID for context")

class WhatsAppAIResponse(BaseModel):
    message: str = Field(..., description="AI response message")
    template_id: Optional[str] = Field(None, description="Template ID if using template")
    params: Optional[List[str]] = Field(None, description="Template parameters")
    media_url: Optional[str] = Field(None, description="Media URL if sending media") 