from sqlalchemy import Column, String, Boolean, DateTime, Text, JSON, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import uuid

from app.database import Base

class WhatsAppTemplate(Base):
    __tablename__ = "whatsapp_templates"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    template_id = Column(String, unique=True, nullable=False)  # Meta/WhatsApp template ID
    facebook_template_id = Column(String, nullable=True)
    name = Column(String, nullable=False)
    category = Column(String, nullable=False)  # AUTHENTICATION, UTILITY, MARKETING
    type = Column(String, nullable=False)  # TEXT, IMAGE, VIDEO, DOCUMENT
    status = Column(String, nullable=False, default="pending")  # pending, approved, rejected, failed
    language = Column(String, nullable=False, default="en_US")
    content = Column(Text, nullable=False)
    media_url = Column(String, nullable=True)
    mime_type = Column(String, nullable=True)
    buttons = Column(JSON, nullable=True)
    footer = Column(String, nullable=True)
    header = Column(String, nullable=True)
    bot_id = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

class WhatsAppMessage(Base):
    __tablename__ = "whatsapp_messages"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    template_id = Column(String, ForeignKey("whatsapp_templates.id"), nullable=True)
    from_addr = Column(String, nullable=False)  # Sender WhatsApp number
    destination_addr = Column(String, nullable=False)  # Receiver WhatsApp number
    message_type = Column(String, nullable=False)  # template, text, media
    content = Column(Text, nullable=True)
    media_url = Column(String, nullable=True)
    params = Column(JSON, nullable=True)  # Template parameters
    status = Column(String, nullable=False, default="pending")  # pending, sent, delivered, read, failed
    job_id = Column(String, nullable=True)  # WhatsApp API job ID
    message_id = Column(String, nullable=True)  # WhatsApp message ID
    error_message = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    user = relationship("User", backref="whatsapp_messages")
    template = relationship("WhatsAppTemplate", backref="messages")

class WhatsAppWebhook(Base):
    __tablename__ = "whatsapp_webhooks"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    broadcast_id = Column(String, nullable=True)
    message_id = Column(String, nullable=True)
    status = Column(String, nullable=False)  # sent, delivered, read, failed
    destination = Column(String, nullable=False)  # Phone number
    message = Column(Text, nullable=True)
    timestamp = Column(DateTime(timezone=True), nullable=True)
    raw_data = Column(JSON, nullable=True)  # Store complete webhook data
    processed = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

class WhatsAppSession(Base):
    __tablename__ = "whatsapp_sessions"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    phone_number = Column(String, nullable=False)
    session_status = Column(String, nullable=False, default="active")  # active, inactive, blocked
    last_message_time = Column(DateTime(timezone=True), nullable=True)
    conversation_context = Column(JSON, nullable=True)  # Store conversation context for AI
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    user = relationship("User", backref="whatsapp_sessions") 