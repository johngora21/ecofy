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