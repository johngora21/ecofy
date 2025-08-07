from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form, Query
from typing import List, Optional
import logging
from bson import ObjectId
from datetime import datetime

from app.api.deps import get_current_user
from app.database import get_database
from app.schemas.farm import FarmCreate, FarmResponse, CropHistory, Coordinates, SoilParameters, FarmBoundary
# from app.api.routes.external import get_satellite_soil_data
from app.utils.mongo_utils import serialize_mongo_doc

router = APIRouter()
logger = logging.getLogger(__name__)

@router.get("", response_model=List[FarmResponse])
def get_farms(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get all farms for the current user"""
    try:
        farms = db.farms.find({"user_id": current_user["_id"]})
        return [serialize_mongo_doc(farm) for farm in farms]
    except Exception as e:
        logger.error(f"Error fetching farms: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

@router.get("/{farm_id}", response_model=FarmResponse)
def get_farm(
    farm_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get a specific farm by ID"""
    try:
        farm = db.farms.find_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
        if not farm:
            raise HTTPException(status_code=404, detail="Farm not found")
        return serialize_mongo_doc(farm)
    except Exception as e:
        logger.error(f"Error fetching farm {farm_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

@router.post("", response_model=FarmResponse)
def create_farm(
    farm_data: FarmCreate,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Create a new farm"""
    try:
        farm_doc = {
            "user_id": current_user["_id"],
            "name": farm_data.name,
            "location": farm_data.location,
            "size": farm_data.size,
            "topography": farm_data.topography,
            "coordinates": farm_data.coordinates.dict() if farm_data.coordinates else None,
            "soil_params": farm_data.soil_params.dict() if farm_data.soil_params else {},
            "crop_history": [crop.dict() for crop in farm_data.crop_history] if farm_data.crop_history else [],
            "farm_boundary": farm_data.farm_boundary.dict() if farm_data.farm_boundary else None,
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow()
        }
        
        result = db.farms.insert_one(farm_doc)
        farm_doc["_id"] = str(result.inserted_id)
        
        return serialize_mongo_doc(farm_doc)
    except Exception as e:
        logger.error(f"Error creating farm: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

@router.put("/{farm_id}", response_model=FarmResponse)
def update_farm(
    farm_id: str,
    farm_data: FarmCreate,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Update a farm"""
    try:
        # Check if farm exists and belongs to user
        existing_farm = db.farms.find_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
        if not existing_farm:
            raise HTTPException(status_code=404, detail="Farm not found")
        
        update_data = {
            "name": farm_data.name,
            "location": farm_data.location,
            "size": farm_data.size,
            "topography": farm_data.topography,
            "coordinates": farm_data.coordinates.dict() if farm_data.coordinates else None,
            "soil_params": farm_data.soil_params.dict() if farm_data.soil_params else {},
            "crop_history": [crop.dict() for crop in farm_data.crop_history] if farm_data.crop_history else [],
            "farm_boundary": farm_data.farm_boundary.dict() if farm_data.farm_boundary else None,
            "updated_at": datetime.utcnow()
        }
        
        db.farms.update_one(
            {"_id": ObjectId(farm_id)},
            {"$set": update_data}
        )
        
        updated_farm = db.farms.find_one({"_id": ObjectId(farm_id)})
        return serialize_mongo_doc(updated_farm)
    except Exception as e:
        logger.error(f"Error updating farm {farm_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

@router.delete("/{farm_id}")
def delete_farm(
    farm_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Delete a farm"""
    try:
        # Check if farm exists and belongs to user
        existing_farm = db.farms.find_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
        if not existing_farm:
            raise HTTPException(status_code=404, detail="Farm not found")
        
        db.farms.delete_one({"_id": ObjectId(farm_id)})
        return {"message": "Farm deleted successfully"}
    except Exception as e:
        logger.error(f"Error deleting farm {farm_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

@router.post("/{farm_id}/analyze-soil")
def analyze_soil(
    farm_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Analyze soil for a specific farm"""
    try:
        farm = db.farms.find_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
        if not farm:
            raise HTTPException(status_code=404, detail="Farm not found")
        
        # Get soil analysis data (mock for now)
        soil_analysis = {
            "moisture": "65%",
            "organic_carbon": "2.8%",
            "texture": "Loamy",
            "ph": "6.7",
            "ec": "0.32 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Low, K: High"
        }
        
        # Update farm with soil analysis
        db.farms.update_one(
            {"_id": ObjectId(farm_id)},
            {"$set": {"soil_params": soil_analysis, "updated_at": datetime.utcnow()}}
        )
        
        return {"message": "Soil analysis completed", "soil_data": soil_analysis}
    except Exception as e:
        logger.error(f"Error analyzing soil for farm {farm_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}") 