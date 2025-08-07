from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form, Query
from typing import List, Optional
import logging
from bson import ObjectId
from datetime import datetime

from app.api.deps import get_current_user
from app.database import get_database
from app.schemas.farm import FarmCreate, FarmResponse, CropHistory, Coordinates, SoilParameters, FarmBoundary, SoilAnalysis, ClimateData, TopographyData
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
            "description": farm_data.description,
            "coordinates": farm_data.coordinates.dict() if farm_data.coordinates else None,
            "farm_boundary": [boundary.dict() for boundary in farm_data.farm_boundary] if farm_data.farm_boundary else None,
            "soil_analysis": farm_data.soil_analysis.dict() if farm_data.soil_analysis else None,
            "climate_data": farm_data.climate_data.dict() if farm_data.climate_data else None,
            "topography_data": farm_data.topography_data.dict() if farm_data.topography_data else None,
            "selected_crops": farm_data.selected_crops if farm_data.selected_crops else [],
            "soil_params": farm_data.soil_params.dict() if farm_data.soil_params else None,  # Keep for backward compatibility
            "crop_history": [crop.dict() for crop in farm_data.crop_history] if farm_data.crop_history else [],
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
            "description": farm_data.description,
            "coordinates": farm_data.coordinates.dict() if farm_data.coordinates else None,
            "farm_boundary": [boundary.dict() for boundary in farm_data.farm_boundary] if farm_data.farm_boundary else None,
            "soil_analysis": farm_data.soil_analysis.dict() if farm_data.soil_analysis else None,
            "climate_data": farm_data.climate_data.dict() if farm_data.climate_data else None,
            "topography_data": farm_data.topography_data.dict() if farm_data.topography_data else None,
            "selected_crops": farm_data.selected_crops if farm_data.selected_crops else [],
            "soil_params": farm_data.soil_params.dict() if farm_data.soil_params else None,  # Keep for backward compatibility
            "crop_history": [crop.dict() for crop in farm_data.crop_history] if farm_data.crop_history else [],
            "updated_at": datetime.utcnow()
        }
        
        # Remove None values to avoid overwriting with None
        update_data = {k: v for k, v in update_data.items() if v is not None}
        
        result = db.farms.update_one(
            {"_id": ObjectId(farm_id), "user_id": current_user["_id"]},
            {"$set": update_data}
        )
        
        if result.modified_count == 0:
            raise HTTPException(status_code=404, detail="Farm not found or no changes made")
        
        # Get updated farm
        updated_farm = db.farms.find_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
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
        result = db.farms.delete_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
        if result.deleted_count == 0:
            raise HTTPException(status_code=404, detail="Farm not found")
        return {"message": "Farm deleted successfully"}
    except Exception as e:
        logger.error(f"Error deleting farm {farm_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

@router.post("/{farm_id}/analyze-soil")
async def analyze_soil(
    farm_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Analyze soil for a specific farm"""
    try:
        # Get farm coordinates
        farm = db.farms.find_one({"_id": ObjectId(farm_id), "user_id": current_user["_id"]})
        if not farm:
            raise HTTPException(status_code=404, detail="Farm not found")
        
        # Extract coordinates
        coordinates = farm.get("coordinates", {})
        lat = float(coordinates.get("lat", 0))
        lng = float(coordinates.get("lng", 0))
        
        if lat == 0 and lng == 0:
            raise HTTPException(status_code=400, detail="Farm coordinates not available")
        
        # Call external soil analysis API
        from app.api.routes.external import get_farm_soil_data
        soil_data = await get_farm_soil_data(lat, lng, current_user)
        
        # Update farm with soil analysis data
        update_data = {
            "soil_analysis": {
                "ph": soil_data.get("ph"),
                "salinity": soil_data.get("salinity"),
                "soil_temp": soil_data.get("soil_temp"),
                "npk_n": soil_data.get("npk_n"),
                "npk_p": soil_data.get("npk_p"),
                "npk_k": soil_data.get("npk_k"),
                "organic_matter": soil_data.get("organic_matter"),
                "soil_structure": soil_data.get("soil_structure"),
                "soil_type": soil_data.get("soil_type"),
            },
            "climate_data": {
                "climate_zone": soil_data.get("climate_zone"),
                "seasonal_pattern": soil_data.get("seasonal_pattern"),
                "average_temperature": soil_data.get("average_temperature"),
                "annual_rainfall": soil_data.get("annual_rainfall"),
                "dry_season_months": soil_data.get("dry_season_months"),
                "wet_season_months": soil_data.get("wet_season_months"),
            },
            "topography_data": {
                "elevation": soil_data.get("elevation"),
                "slope": soil_data.get("slope"),
                "landscape_type": soil_data.get("landscape_type"),
                "drainage": soil_data.get("drainage"),
                "erosion_risk": soil_data.get("erosion_risk"),
            },
            "updated_at": datetime.utcnow()
        }
        
        db.farms.update_one(
            {"_id": ObjectId(farm_id), "user_id": current_user["_id"]},
            {"$set": update_data}
        )
        
        return {"message": "Soil analysis completed", "data": soil_data}
        
    except Exception as e:
        logger.error(f"Error analyzing soil for farm {farm_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}") 