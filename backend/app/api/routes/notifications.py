from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from bson import ObjectId
from datetime import datetime

from app.api.deps import get_current_user
from app.database import get_database

router = APIRouter()

@router.get("", response_model=List[dict])
async def get_notifications(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    notifications = list(db.notifications.find({"user_id": current_user["_id"]}).sort("created_at", -1))
    return notifications


@router.patch("/{notification_id}/read", response_model=dict)
async def mark_notification_as_read(
    notification_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    notification = db.notifications.find_one({
        "_id": ObjectId(notification_id),
        "user_id": current_user["_id"]
    })
    
    if not notification:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Notification not found"
        )
    
    db.notifications.update_one(
        {"_id": ObjectId(notification_id)},
        {"$set": {"is_read": True}}
    )
    
    # Get updated notification
    updated_notification = db.notifications.find_one({"_id": ObjectId(notification_id)})
    return updated_notification


@router.patch("/read-all", response_model=dict)
async def mark_all_notifications_as_read(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    db.notifications.update_many(
        {
            "user_id": current_user["_id"],
            "is_read": False
        },
        {"$set": {"is_read": True}}
    )
    
    return {"success": True} 