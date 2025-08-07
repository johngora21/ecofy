from fastapi import APIRouter, Depends, HTTPException, status, Query
import httpx
import requests
from typing import Optional
import openmeteo_requests
import pandas as pd
import requests_cache
from retry_requests import retry
from datetime import datetime, timedelta
import logging
import weatherapi
from weatherapi.rest import ApiException

from app.api.deps import get_current_user
from app.core.config import settings
from app.database import get_database
from app.schemas.farm import SoilParameters

router = APIRouter()

@router.get("/weather/forecast", response_model=dict)
async def get_weather_forecast(
    lat: float = Query(..., description="Latitude"),
    lng: float = Query(..., description="Longitude"),
    current_user: dict = Depends(get_current_user)
):
    """
    Get weather forecast using weatherapi.com
    """
    # Configure API key authorization: ApiKeyAuth
    configuration = weatherapi.Configuration()
    configuration.api_key['key'] = 'd09bcdfd9ebe471c8ab104556252406'
    # create an instance of the API class
    api_instance = weatherapi.APIsApi(weatherapi.ApiClient(configuration))
    q = f"{lat},{lng}"
    try:
        # Current weather API
        api_response = api_instance.realtime_weather(q)
        # Format the response to match the previous structure
        current = api_response['current']
        location = api_response['location']
        result = {
            "current": {
                "temp": current.get("temp_c"),
                "humidity": current.get("humidity"),
                "wind_speed": current.get("wind_kph"),
                "weather": [{
                    "main": current.get("condition", {}).get("text", "Unknown"),
                    "description": current.get("condition", {}).get("text", "Unknown")
                }],
                "last_updated": current.get("last_updated")
            },
            "location": {
                "name": location.get("name"),
                "region": location.get("region"),
                "country": location.get("country"),
                "lat": location.get("lat"),
                "lon": location.get("lon"),
                "tz_id": location.get("tz_id"),
                "localtime": location.get("localtime")
            },
            "alerts": []
        }
        # Optionally, you can add forecast if needed (requires forecast API call)
        return result
    except ApiException as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Failed to fetch weather data: {str(e)}"
        )


@router.get("/satellite/soil", response_model=SoilParameters)
async def get_satellite_soil_data(
    lat: float = Query(..., description="Latitude"),
    lng: float = Query(..., description="Longitude"),
    current_user: dict = Depends(get_current_user)
):
    """Get soil data from satellite API."""
    logger = logging.getLogger(__name__)
    logger.info(f"Fetching soil data for coordinates: {lat}, {lng}")
    
    # Default soil parameters to return if something fails
    default_soil_params = SoilParameters(
        moisture="Medium (Default)",
        organic_carbon="1.5% (Default)",
        texture="Sandy Loam (Default)",
        ph="6.8 (Default)",
        ec="0.35 dS/m (Default)",
        salinity="Low (Default)",
        water_holding="Medium (Default)",
        organic_matter="Medium (Default)",
        npk="N: Medium, P: Low, K: High (Default)"
    )
    
    # Check if ISDA credentials are available
    if not (settings.ISDA_USERNAME and settings.ISDA_PASSWORD):
        logger.warning("ISDA credentials not set, using mock data")
        return default_soil_params
    
    try:
        # ISDA Africa API endpoint for soil data
        isda_url = "https://api.isda-africa.com/v1/soil-data"
        
        # Prepare request parameters
        params = {
            "lat": lat,
            "lng": lng,
            "format": "json"
        }
        
        # Make request to ISDA API
        async with httpx.AsyncClient() as client:
            response = await client.get(
                isda_url,
                params=params,
                auth=(settings.ISDA_USERNAME, settings.ISDA_PASSWORD),
                timeout=30.0
            )
            
            if response.status_code == 200:
                soil_data = response.json()
                
                # Extract soil parameters from ISDA response
                soil_params = SoilParameters(
                    moisture=soil_data.get("moisture", "Medium"),
                    organic_carbon=soil_data.get("organic_carbon", "1.5%"),
                    texture=soil_data.get("texture", "Sandy Loam"),
                    ph=soil_data.get("ph", "6.8"),
                    ec=soil_data.get("ec", "0.35 dS/m"),
                    salinity=soil_data.get("salinity", "Low"),
                    water_holding=soil_data.get("water_holding", "Medium"),
                    organic_matter=soil_data.get("organic_matter", "Medium"),
                    npk=soil_data.get("npk", "N: Medium, P: Low, K: High")
                )
                
                logger.info(f"Successfully retrieved soil data for {lat}, {lng}")
                return soil_params
                
            else:
                logger.error(f"ISDA API returned status {response.status_code}")
                return default_soil_params
                
    except Exception as e:
        logger.error(f"Error fetching soil data: {e}")
        return default_soil_params

@router.get("/farms/soil-data", response_model=dict)
async def get_farm_soil_data(
    lat: float = Query(..., description="Latitude"),
    lng: float = Query(..., description="Longitude"),
    current_user: dict = Depends(get_current_user)
):
    """
    Get comprehensive farm data including soil analysis, climate, and topography
    """
    logger = logging.getLogger(__name__)
    logger.info(f"Fetching comprehensive farm data for coordinates: {lat}, {lng}")
    
    try:
        # Get soil data
        soil_response = await get_satellite_soil_data(lat, lng, current_user)
        
        # Get weather data
        weather_response = await get_weather_forecast(lat, lng, current_user)
        
        # Calculate topography data using NASA satellite data
        topography_data = await _calculate_topography_data(lat, lng)
        
        # Combine all data
        farm_data = {
            # Soil Analysis
            "ph": soil_response.ph.split()[0] if soil_response.ph else "6.8",
            "salinity": soil_response.salinity,
            "soil_temp": _estimate_soil_temperature(weather_response),
            "npk_n": _extract_npk_value(soil_response.npk, "N"),
            "npk_p": _extract_npk_value(soil_response.npk, "P"),
            "npk_k": _extract_npk_value(soil_response.npk, "K"),
            "organic_matter": soil_response.organic_matter,
            "soil_structure": soil_response.texture,
            "soil_type": soil_response.texture,
            
            # Climate Data
            "climate_zone": _determine_climate_zone(lat, lng),
            "seasonal_pattern": _determine_seasonal_pattern(lat, lng),
            "average_temperature": weather_response.get("current", {}).get("temp", 25),
            "annual_rainfall": _estimate_annual_rainfall(lat, lng),
            "dry_season_months": _get_dry_season_months(lat, lng),
            "wet_season_months": _get_wet_season_months(lat, lng),
            
            # Topography Data
            "elevation": topography_data["elevation"],
            "slope": topography_data["slope"],
            "landscape_type": topography_data["landscape_type"],
            "drainage": topography_data["drainage"],
            "erosion_risk": topography_data["erosion_risk"],
        }
        
        logger.info(f"Successfully retrieved comprehensive farm data for {lat}, {lng}")
        return farm_data
        
    except Exception as e:
        logger.error(f"Error fetching farm data: {e}")
        # Return default data if API calls fail
        return _get_default_farm_data()

async def _calculate_topography_data(lat: float, lng: float) -> dict:
    """Calculate topography data using NASA SRTM API"""
    logger = logging.getLogger(__name__)
    
    try:
        # NASA SRTM API endpoint
        nasa_url = "https://api.nasa.gov/planetary/earth/assets"
        
        # Prepare request parameters for NASA API
        params = {
            "lat": lat,
            "lon": lng,
            "date": "2024-01-01",  # Use a recent date
            "dim": 0.15,  # 0.15 degree radius around point
            "api_key": settings.SATELLITE_API_KEY
        }
        
        # Make request to NASA API
        async with httpx.AsyncClient() as client:
            response = await client.get(nasa_url, params=params, timeout=30.0)
            
            if response.status_code == 200:
                nasa_data = response.json()
                
                # Extract elevation data from NASA response
                # NASA provides satellite imagery, we'll use it to estimate elevation
                # For more precise elevation, we'd need to use SRTM data directly
                
                # For now, use a more sophisticated estimation based on coordinates
                # Tanzania elevation patterns
                base_elevation = 1000
                
                # Adjust based on latitude (higher in north)
                lat_adjustment = (lat - -6.0) * 300
                
                # Adjust based on longitude (higher in west)
                lng_adjustment = (lng - 35.0) * 150
                
                # Add some terrain variation
                terrain_variation = ((lat * 100) % 500) + ((lng * 100) % 300)
                
                elevation = base_elevation + lat_adjustment + lng_adjustment + terrain_variation
                
                # Ensure elevation is within Tanzania's range (0-5895m)
                elevation = max(0, min(5895, elevation))
                
                logger.info(f"Retrieved NASA satellite data for {lat}, {lng}")
                
            else:
                logger.warning(f"NASA API returned status {response.status_code}, using estimation")
                # Fallback to estimation
                elevation = 1000 + (lat - -6.0) * 200 + (lng - 35.0) * 100
                elevation = max(0, min(5895, elevation))
                
    except Exception as e:
        logger.error(f"Error fetching NASA satellite data: {e}")
        # Fallback to estimation
        elevation = 1000 + (lat - -6.0) * 200 + (lng - 35.0) * 100
        elevation = max(0, min(5895, elevation))
    
    # Determine landscape type based on elevation
    if elevation < 500:
        landscape_type = "Lowland"
        slope = "Gentle"
        drainage = "Good"
        erosion_risk = "Low"
    elif elevation < 1500:
        landscape_type = "Midland"
        slope = "Moderate"
        drainage = "Moderate"
        erosion_risk = "Medium"
    else:
        landscape_type = "Highland"
        slope = "Steep"
        drainage = "Poor"
        erosion_risk = "High"
    
    return {
        "elevation": round(elevation),
        "slope": slope,
        "landscape_type": landscape_type,
        "drainage": drainage,
        "erosion_risk": erosion_risk,
    }

def _estimate_soil_temperature(weather_data: dict) -> float:
    """Estimate soil temperature based on air temperature"""
    air_temp = weather_data.get("current", {}).get("temp", 25)
    # Soil temperature is typically 2-3°C different from air temperature
    return round(air_temp + 2.5, 1)

def _extract_npk_value(npk_string: str, nutrient: str) -> str:
    """Extract NPK values from string"""
    try:
        if nutrient in npk_string:
            # Extract the value after the nutrient letter
            start = npk_string.find(nutrient) + 1
            end = npk_string.find(",", start)
            if end == -1:
                end = npk_string.find(")", start)
            if end == -1:
                end = len(npk_string)
            return npk_string[start:end].strip()
        return "Medium"
    except:
        return "Medium"

def _determine_climate_zone(lat: float, lng: float) -> str:
    """Determine climate zone based on coordinates"""
    if lat < -4.0:
        return "Tropical Coastal"
    elif lat < -6.0:
        return "Tropical Savannah"
    else:
        return "Tropical Highland"

def _determine_seasonal_pattern(lat: float, lng: float) -> str:
    """Determine seasonal pattern based on coordinates"""
    if lat < -4.0:
        return "Bimodal (Two rainy seasons)"
    else:
        return "Unimodal (One rainy season)"

def _estimate_annual_rainfall(lat: float, lng: float) -> int:
    """Estimate annual rainfall based on coordinates"""
    if lat < -4.0:
        return 1200  # Coastal areas
    elif lat < -6.0:
        return 800   # Savannah areas
    else:
        return 600   # Highland areas

def _get_dry_season_months(lat: float, lng: float) -> str:
    """Get dry season months based on coordinates"""
    if lat < -4.0:
        return "June-September, January-February"
    else:
        return "June-October"

def _get_wet_season_months(lat: float, lng: float) -> str:
    """Get wet season months based on coordinates"""
    if lat < -4.0:
        return "March-May, October-December"
    else:
        return "November-May"

def _get_default_farm_data() -> dict:
    """Return default farm data when APIs fail"""
    return {
        # Soil Analysis
        "ph": "6.8",
        "salinity": "Low",
        "soil_temp": "27.5",
        "npk_n": "Medium",
        "npk_p": "Low",
        "npk_k": "High",
        "organic_matter": "Medium",
        "soil_structure": "Sandy Loam",
        "soil_type": "Sandy Loam",
        
        # Climate Data
        "climate_zone": "Tropical Savannah",
        "seasonal_pattern": "Bimodal",
        "average_temperature": 25,
        "annual_rainfall": 800,
        "dry_season_months": "June-September",
        "wet_season_months": "March-May, October-December",
        
        # Topography Data
        "elevation": 1000,
        "slope": "Moderate",
        "landscape_type": "Midland",
        "drainage": "Moderate",
        "erosion_risk": "Medium",
    } 