from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Optional
from bson import ObjectId

from app.api.deps import get_current_user
from app.database import get_database
from app.schemas.user import UserBase, UserResponse
from app.utils.mongo_utils import serialize_mongo_doc

router = APIRouter()

@router.get("/me", response_model=UserResponse)
async def get_current_user_info(current_user: dict = Depends(get_current_user)):
    return current_user

@router.put("/me", response_model=UserResponse)
async def update_user(
    user_in: UserBase,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    # Update user information
    update_data = {
        "full_name": user_in.full_name,
        "phone_number": user_in.phone_number,
        "location": user_in.location,
        "preferred_language": user_in.preferred_language
    }
    
    await db.users.update_one(
        {"_id": current_user["_id"]},
        {"$set": update_data}
    )
    
    # Get updated user
    updated_user = await db.users.find_one({"_id": current_user["_id"]})
    return updated_user

@router.patch("/language", response_model=dict)
async def update_language(
    language_data: dict,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    preferred_language = language_data.get("preferred_language")
    if not preferred_language:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Preferred language is required"
        )
    
    await db.users.update_one(
        {"_id": current_user["_id"]},
        {"$set": {"preferred_language": preferred_language}}
    )
    
    return {
        "success": True,
        "preferred_language": preferred_language
    }

# Admin endpoints for user management
@router.get("/admin/all")
async def get_all_users(
    role: Optional[str] = Query(None, description="Filter by user role"),
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get all users for admin management (admin only)"""
    # Check if current user is admin
    if current_user.get("role") not in ["admin", "super_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    try:
        # Build filter
        filter_query = {}
        if role:
            filter_query["role"] = role
        
        # Calculate skip
        skip = (page - 1) * limit
        
        # Get total count
        total = db.users.count_documents(filter_query)
        
        # Get users
        users_cursor = db.users.find(filter_query).skip(skip).limit(limit)
        users = [serialize_mongo_doc(user) for user in users_cursor]
        
        return {
            "items": users,
            "total": total,
            "page": page,
            "limit": limit,
            "pages": (total + limit - 1) // limit
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching users: {e}")

@router.get("/admin/by-role/{role}")
async def get_users_by_role(
    role: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get users by specific role for admin management (admin only)"""
    # Check if current user is admin
    if current_user.get("role") not in ["admin", "super_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    try:
        users_cursor = db.users.find({"role": role})
        users = [serialize_mongo_doc(user) for user in users_cursor]
        
        return {
            "role": role,
            "users": users,
            "count": len(users)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching users by role: {e}")

@router.get("/admin/statistics")
async def get_user_statistics(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get user statistics for admin dashboard (admin only)"""
    # Check if current user is admin
    if current_user.get("role") not in ["admin", "super_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    try:
        # Get total users
        total_users = db.users.count_documents({})
        
        # Get users by role
        farmers = db.users.count_documents({"role": "farmer"})
        buyers = db.users.count_documents({"role": "buyer"})
        suppliers = db.users.count_documents({"role": "supplier"})
        admins = db.users.count_documents({"role": {"$in": ["admin", "super_admin"]}})
        
        # Get active users
        active_users = db.users.count_documents({"is_active": True})
        
        return {
            "total_users": total_users,
            "active_users": active_users,
            "by_role": {
                "farmers": farmers,
                "buyers": buyers,
                "suppliers": suppliers,
                "admins": admins
            }
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching user statistics: {e}")

@router.get("/admin/roles")
async def get_user_roles(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get available user roles and their counts (admin only)"""
    # Check if current user is admin
    if current_user.get("role") not in ["admin", "super_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )
    
    try:
        # Get unique roles and their counts
        pipeline = [
            {"$group": {"_id": "$role", "count": {"$sum": 1}}},
            {"$sort": {"count": -1}}
        ]
        
        role_stats = list(db.users.aggregate(pipeline))
        
        return {
            "roles": role_stats
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching user roles: {e}") 