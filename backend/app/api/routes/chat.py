from fastapi import APIRouter, Depends, HTTPException, status, Body, UploadFile, File
from typing import List, Optional
from datetime import datetime
from bson import ObjectId
import io

from app.api.deps import get_current_user
from app.database import get_database
from app.schemas.chat import ChatSession as ChatSessionSchema
from app.schemas.chat import ChatMessage as ChatMessageSchema
from app.schemas.chat import ChatMessageResponse, MessageType
from app.services.openai_service import openai_service

router = APIRouter()

@router.get("/sessions", response_model=List[ChatSessionSchema])
async def get_chat_sessions(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    sessions = list(db.chat_sessions.find({"user_id": current_user["_id"]}).sort("created_at", -1))
    return sessions


@router.post("/sessions", response_model=ChatSessionSchema)
async def create_chat_session(
    session_data: dict = Body(...),
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    title = session_data.get("title", "New Conversation")
    
    session_doc = {
        "user_id": current_user["_id"],
        "title": title,
        "last_message": None,
        "last_message_time": None,
        "created_at": datetime.utcnow()
    }
    
    result = db.chat_sessions.insert_one(session_doc)
    session_doc["_id"] = result.inserted_id
    
    return session_doc


@router.get("/sessions/{session_id}/messages", response_model=List[ChatMessageResponse])
async def get_chat_messages(
    session_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    # Check if session exists and belongs to user
    session = db.chat_sessions.find_one({
        "_id": ObjectId(session_id),
        "user_id": current_user["_id"]
    })
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat session not found"
        )
    
    messages = list(db.chat_messages.find({"session_id": session_id}).sort("created_at", 1))
    return messages


@router.post("/sessions/{session_id}/messages", response_model=ChatMessageResponse)
async def create_chat_message(
    session_id: str,
    message: ChatMessageSchema,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    # Check if session exists and belongs to user
    session = db.chat_sessions.find_one({
        "_id": ObjectId(session_id),
        "user_id": current_user["_id"]
    })
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat session not found"
        )
    
    # Create user message
    user_message_doc = {
        "session_id": session_id,
        "user_id": current_user["_id"],
        "content": message.content,
        "type": message.type.value,
        "file_url": message.file_url,
        "is_ai": False,
        "created_at": datetime.utcnow()
    }
    
    user_result = db.chat_messages.insert_one(user_message_doc)
    user_message_doc["_id"] = user_result.inserted_id
    
    # Update session with last message
    db.chat_sessions.update_one(
        {"_id": ObjectId(session_id)},
        {
            "$set": {
                "last_message": message.content,
                "last_message_time": datetime.utcnow()
            }
        }
    )
    
    # Generate AI response
    try:
        ai_response = await openai_service.generate_text_response(message.content)
        
        # Create AI message
        ai_message_doc = {
            "session_id": session_id,
            "user_id": None,
            "content": ai_response,
            "type": MessageType.TEXT.value,
            "file_url": None,
            "is_ai": True,
            "created_at": datetime.utcnow()
        }
        
        ai_result = db.chat_messages.insert_one(ai_message_doc)
        ai_message_doc["_id"] = ai_result.inserted_id
        
        # Update session with AI response
        db.chat_sessions.update_one(
            {"_id": ObjectId(session_id)},
            {
                "$set": {
                    "last_message": ai_response,
                    "last_message_time": datetime.utcnow()
                }
            }
        )
        
        return user_message_doc
        
    except Exception as e:
        # If AI fails, still return user message
        return user_message_doc


@router.post("/sessions/{session_id}/audio", response_model=ChatMessageResponse)
async def create_audio_chat_message(
    session_id: str,
    audio_file: UploadFile = File(...),
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    # Check if session exists and belongs to user
    session = db.chat_sessions.find_one({
        "_id": ObjectId(session_id),
        "user_id": current_user["_id"]
    })
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat session not found"
        )
    
    # Read audio file
    audio_bytes = await audio_file.read()
    
    # Transcribe audio
    try:
        transcription = await openai_service.transcribe_audio(audio_bytes)
        
        # Create user message with transcription
        user_message_doc = {
            "session_id": session_id,
            "user_id": current_user["_id"],
            "content": transcription,
            "type": MessageType.AUDIO.value,
            "file_url": None,  # In production, upload to cloud storage
            "is_ai": False,
            "created_at": datetime.utcnow()
        }
        
        user_result = db.chat_messages.insert_one(user_message_doc)
        user_message_doc["_id"] = user_result.inserted_id
        
        # Update session
        db.chat_sessions.update_one(
            {"_id": ObjectId(session_id)},
            {
                "$set": {
                    "last_message": transcription,
                    "last_message_time": datetime.utcnow()
                }
            }
        )
        
        # Generate AI response
        ai_response = await openai_service.generate_text_response(transcription)
        
        # Create AI message
        ai_message_doc = {
            "session_id": session_id,
            "user_id": None,
            "content": ai_response,
            "type": MessageType.TEXT.value,
            "file_url": None,
            "is_ai": True,
            "created_at": datetime.utcnow()
        }
        
        ai_result = db.chat_messages.insert_one(ai_message_doc)
        ai_message_doc["_id"] = ai_result.inserted_id
        
        # Update session with AI response
        db.chat_sessions.update_one(
            {"_id": ObjectId(session_id)},
            {
                "$set": {
                    "last_message": ai_response,
                    "last_message_time": datetime.utcnow()
                }
            }
        )
        
        return user_message_doc
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Audio processing failed: {str(e)}"
        )


@router.delete("/sessions/{session_id}")
async def delete_chat_session(
    session_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    # Check if session exists and belongs to user
    session = db.chat_sessions.find_one({
        "_id": ObjectId(session_id),
        "user_id": current_user["_id"]
    })
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat session not found"
        )
    
    # Delete session and all messages
    db.chat_sessions.delete_one({"_id": ObjectId(session_id)})
    db.chat_messages.delete_many({"session_id": session_id})
    
    return {"message": "Chat session deleted successfully"} 