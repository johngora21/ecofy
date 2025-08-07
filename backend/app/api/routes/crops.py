from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Optional
from bson import ObjectId

from app.api.deps import get_current_user
from app.database import get_database
from app.utils.mongo_utils import serialize_mongo_doc

router = APIRouter()

@router.get("")
def get_crops(
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    category: Optional[str] = None,
    db = Depends(get_database)
):
    """Get crops with pagination and filtering"""
    try:
        # Build filter
        filter_query = {}
        if category:
            filter_query["category"] = category
        
        # Calculate skip
        skip = (page - 1) * limit
        
        # Get total count
        total = db.crops_data.count_documents(filter_query)
        
        # Get crops
        crops_cursor = db.crops_data.find(filter_query).skip(skip).limit(limit)
        crops = [serialize_mongo_doc(crop) for crop in crops_cursor]
        
        return {
            "items": crops,
            "total": total,
            "page": page,
            "limit": limit,
            "pages": (total + limit - 1) // limit
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching crops: {e}")

@router.get("/{crop_id}")
def get_crop(crop_id: str, db = Depends(get_database)):
    """Get a specific crop by ID"""
    try:
        crop = db.crops_data.find_one({"_id": crop_id})
        if not crop:
            raise HTTPException(status_code=404, detail="Crop not found")
        
        return serialize_mongo_doc(crop)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching crop: {e}")

@router.get("/categories")
def get_crop_categories(db = Depends(get_database)):
    """Get all crop categories"""
    try:
        categories = db.crops_data.distinct("category")
        return {"categories": categories}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching crop categories: {e}")

@router.get("/search/{query}")
def search_crops(query: str, db = Depends(get_database)):
    """Search crops by name"""
    try:
        crops_cursor = db.crops_data.find({
            "name": {"$regex": query, "$options": "i"}
        })
        crops = [serialize_mongo_doc(crop) for crop in crops_cursor]
        
        return {"items": crops}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error searching crops: {e}") 