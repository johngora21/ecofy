from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class Coordinates(BaseModel):
    lat: str
    lng: str

class FarmBoundary(BaseModel):
    lat: float
    lng: float

class SoilParameters(BaseModel):
    moisture: str
    organic_carbon: str
    texture: str
    ph: str
    ec: Optional[str] = None
    salinity: Optional[str] = None
    water_holding: Optional[str] = None
    organic_matter: Optional[str] = None
    npk: Optional[str] = None

class SoilAnalysis(BaseModel):
    ph: Optional[str] = None
    salinity: Optional[str] = None
    soil_temp: Optional[str] = None
    npk_n: Optional[str] = None
    npk_p: Optional[str] = None
    npk_k: Optional[str] = None
    organic_matter: Optional[str] = None
    soil_structure: Optional[str] = None
    soil_type: Optional[str] = None

class ClimateData(BaseModel):
    climate_zone: Optional[str] = None
    seasonal_pattern: Optional[str] = None
    average_temperature: Optional[float] = None
    annual_rainfall: Optional[int] = None
    dry_season_months: Optional[str] = None
    wet_season_months: Optional[str] = None

class TopographyData(BaseModel):
    elevation: Optional[int] = None
    slope: Optional[str] = None
    landscape_type: Optional[str] = None
    drainage: Optional[str] = None
    erosion_risk: Optional[str] = None

class CropHistory(BaseModel):
    crop: str
    season: str
    yield_amount: str
    
class FarmBase(BaseModel):
    name: str
    location: str
    size: str
    description: Optional[str] = None
    coordinates: Coordinates
    farm_boundary: Optional[List[FarmBoundary]] = None
    soil_analysis: Optional[SoilAnalysis] = None
    climate_data: Optional[ClimateData] = None
    topography_data: Optional[TopographyData] = None
    selected_crops: Optional[List[str]] = None
    soil_params: Optional[SoilParameters] = None  # Keep for backward compatibility
   

class FarmCreate(BaseModel):
    name: str
    location: str
    size: str
    description: Optional[str] = None
    coordinates: Coordinates
    farm_boundary: Optional[List[FarmBoundary]] = None
    soil_analysis: Optional[SoilAnalysis] = None
    climate_data: Optional[ClimateData] = None
    topography_data: Optional[TopographyData] = None
    selected_crops: Optional[List[str]] = None

class FarmUpdate(BaseModel):
    name: Optional[str] = None
    location: Optional[str] = None
    size: Optional[str] = None
    description: Optional[str] = None
    coordinates: Optional[Coordinates] = None
    farm_boundary: Optional[List[FarmBoundary]] = None
    soil_analysis: Optional[SoilAnalysis] = None
    climate_data: Optional[ClimateData] = None
    topography_data: Optional[TopographyData] = None
    selected_crops: Optional[List[str]] = None

class FarmResponse(FarmBase):
    id: str
    user_id: str
    image: Optional[str] = None
    crop_history: List[CropHistory] = []
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True 
    image: Optional[str] = None
    crop_history: List[CropHistory] = []
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True 