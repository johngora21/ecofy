#!/usr/bin/env python3
"""
Script to display detailed farm information
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
import json

# Database connection
DATABASE_URL = "sqlite:///./ecofy.db"
engine = create_engine(DATABASE_URL)

def show_farm_details():
    """Display detailed information about all farms"""
    print("🌾 TANZANIA FARM DATA - DETAILED OVERVIEW 🌾")
    print("=" * 60)
    
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT id, name, location, size, topography, coordinates, 
                   soil_params, crop_history, created_at
            FROM farms
            ORDER BY name
        """))
        
        farms = result.fetchall()
        
        if not farms:
            print("No farms found in database.")
            return
        
        for i, farm in enumerate(farms, 1):
            print(f"\n🏡 FARM #{i}: {farm[1].upper()}")
            print("-" * 40)
            
            # Basic info
            print(f"📍 Location: {farm[2]}")
            print(f"📏 Size: {farm[3]}")
            print(f"🏔️  Topography: {farm[4]}")
            print(f"🆔 ID: {farm[0]}")
            print(f"📅 Created: {farm[8]}")
            
            # Coordinates
            if farm[5]:
                coords = json.loads(farm[5])
                print(f"🗺️  Coordinates: {coords['lat']}, {coords['lng']}")
            
            # Soil parameters
            if farm[6]:
                soil = json.loads(farm[6])
                print("\n🌱 SOIL ANALYSIS:")
                print(f"   💧 Moisture: {soil.get('moisture', 'N/A')}")
                print(f"   🍃 Organic Carbon: {soil.get('organic_carbon', 'N/A')}")
                print(f"   🏗️  Texture: {soil.get('texture', 'N/A')}")
                print(f"   🧪 pH: {soil.get('ph', 'N/A')}")
                print(f"   ⚡ EC: {soil.get('ec', 'N/A')}")
                print(f"   🧂 Salinity: {soil.get('salinity', 'N/A')}")
                print(f"   💦 Water Holding: {soil.get('water_holding', 'N/A')}")
                print(f"   🌿 Organic Matter: {soil.get('organic_matter', 'N/A')}")
                print(f"   🌱 NPK: {soil.get('npk', 'N/A')}")
            
            # Crop history
            if farm[7]:
                crops = json.loads(farm[7])
                print(f"\n🌾 CROP HISTORY ({len(crops)} crops):")
                for crop in crops:
                    print(f"   • {crop['crop']} ({crop['season']}): {crop['yield_amount']}")
            
            print("\n" + "=" * 60)
    
    # Summary statistics
    print("\n📊 SUMMARY STATISTICS:")
    print("-" * 30)
    
    with engine.connect() as conn:
        # Total farms
        result = conn.execute(text("SELECT COUNT(*) FROM farms"))
        total_farms = result.fetchone()[0]
        print(f"🏡 Total Farms: {total_farms}")
        
        # Farms by region
        result = conn.execute(text("SELECT location, COUNT(*) FROM farms GROUP BY location"))
        regions = result.fetchall()
        print(f"📍 Farms by Region:")
        for region, count in regions:
            print(f"   • {region}: {count} farms")
        
        # Total acreage
        result = conn.execute(text("SELECT SUM(CAST(REPLACE(REPLACE(size, ' acres', ''), ' ', '') AS INTEGER)) FROM farms"))
        total_acres = result.fetchone()[0] or 0
        print(f"📏 Total Acreage: {total_acres} acres")
        
        # Average farm size
        result = conn.execute(text("SELECT AVG(CAST(REPLACE(REPLACE(size, ' acres', ''), ' ', '') AS FLOAT)) FROM farms"))
        avg_size = result.fetchone()[0] or 0
        print(f"📐 Average Farm Size: {avg_size:.1f} acres")

if __name__ == "__main__":
    show_farm_details() 
 
"""
Script to display detailed farm information
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
import json

# Database connection
DATABASE_URL = "sqlite:///./ecofy.db"
engine = create_engine(DATABASE_URL)

def show_farm_details():
    """Display detailed information about all farms"""
    print("🌾 TANZANIA FARM DATA - DETAILED OVERVIEW 🌾")
    print("=" * 60)
    
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT id, name, location, size, topography, coordinates, 
                   soil_params, crop_history, created_at
            FROM farms
            ORDER BY name
        """))
        
        farms = result.fetchall()
        
        if not farms:
            print("No farms found in database.")
            return
        
        for i, farm in enumerate(farms, 1):
            print(f"\n🏡 FARM #{i}: {farm[1].upper()}")
            print("-" * 40)
            
            # Basic info
            print(f"📍 Location: {farm[2]}")
            print(f"📏 Size: {farm[3]}")
            print(f"🏔️  Topography: {farm[4]}")
            print(f"🆔 ID: {farm[0]}")
            print(f"📅 Created: {farm[8]}")
            
            # Coordinates
            if farm[5]:
                coords = json.loads(farm[5])
                print(f"🗺️  Coordinates: {coords['lat']}, {coords['lng']}")
            
            # Soil parameters
            if farm[6]:
                soil = json.loads(farm[6])
                print("\n🌱 SOIL ANALYSIS:")
                print(f"   💧 Moisture: {soil.get('moisture', 'N/A')}")
                print(f"   🍃 Organic Carbon: {soil.get('organic_carbon', 'N/A')}")
                print(f"   🏗️  Texture: {soil.get('texture', 'N/A')}")
                print(f"   🧪 pH: {soil.get('ph', 'N/A')}")
                print(f"   ⚡ EC: {soil.get('ec', 'N/A')}")
                print(f"   🧂 Salinity: {soil.get('salinity', 'N/A')}")
                print(f"   💦 Water Holding: {soil.get('water_holding', 'N/A')}")
                print(f"   🌿 Organic Matter: {soil.get('organic_matter', 'N/A')}")
                print(f"   🌱 NPK: {soil.get('npk', 'N/A')}")
            
            # Crop history
            if farm[7]:
                crops = json.loads(farm[7])
                print(f"\n🌾 CROP HISTORY ({len(crops)} crops):")
                for crop in crops:
                    print(f"   • {crop['crop']} ({crop['season']}): {crop['yield_amount']}")
            
            print("\n" + "=" * 60)
    
    # Summary statistics
    print("\n📊 SUMMARY STATISTICS:")
    print("-" * 30)
    
    with engine.connect() as conn:
        # Total farms
        result = conn.execute(text("SELECT COUNT(*) FROM farms"))
        total_farms = result.fetchone()[0]
        print(f"🏡 Total Farms: {total_farms}")
        
        # Farms by region
        result = conn.execute(text("SELECT location, COUNT(*) FROM farms GROUP BY location"))
        regions = result.fetchall()
        print(f"📍 Farms by Region:")
        for region, count in regions:
            print(f"   • {region}: {count} farms")
        
        # Total acreage
        result = conn.execute(text("SELECT SUM(CAST(REPLACE(REPLACE(size, ' acres', ''), ' ', '') AS INTEGER)) FROM farms"))
        total_acres = result.fetchone()[0] or 0
        print(f"📏 Total Acreage: {total_acres} acres")
        
        # Average farm size
        result = conn.execute(text("SELECT AVG(CAST(REPLACE(REPLACE(size, ' acres', ''), ' ', '') AS FLOAT)) FROM farms"))
        avg_size = result.fetchone()[0] or 0
        print(f"📐 Average Farm Size: {avg_size:.1f} acres")

if __name__ == "__main__":
    show_farm_details() 
 