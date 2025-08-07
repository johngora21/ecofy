#!/usr/bin/env python3
"""
Simple script to add test farm data
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
from datetime import datetime
import uuid
import json

# Database connection
DATABASE_URL = "sqlite:///./ecofy.db"
engine = create_engine(DATABASE_URL)

# Tanzania-specific farm data
TANZANIA_FARMS = [
    {
        "id": str(uuid.uuid4()),
        "name": "Green Valley Farm",
        "location": "Arusha",
        "size": "25 acres",
        "topography": "Flat to gently undulating",
        "coordinates": json.dumps({"lat": "-3.3731", "lng": "36.6822"}),
        "soil_params": json.dumps({
            "moisture": "60%",
            "organic_carbon": "2.5%",
            "texture": "Loamy",
            "ph": "6.5",
            "ec": "0.35 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Low, K: High"
        }),
        "crop_history": json.dumps([
            {"crop": "Maize", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "2.3 tons"},
            {"crop": "Tomatoes", "season": "2023-2024", "yield_amount": "15.2 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Sunrise Agricultural Estate",
        "location": "Morogoro",
        "size": "50 acres",
        "topography": "Gently sloping",
        "coordinates": json.dumps({"lat": "-6.8235", "lng": "37.6822"}),
        "soil_params": json.dumps({
            "moisture": "45%",
            "organic_carbon": "1.8%",
            "texture": "Sandy Loam",
            "ph": "5.8",
            "ec": "0.28 dS/m",
            "salinity": "Very Low",
            "water_holding": "Low",
            "organic_matter": "Low",
            "npk": "N: Low, P: Medium, K: Medium"
        }),
        "crop_history": json.dumps([
            {"crop": "Rice", "season": "2023-2024", "yield_amount": "12.5 tons"},
            {"crop": "Cassava", "season": "2023-2024", "yield_amount": "45.8 tons"},
            {"crop": "Sweet Potatoes", "season": "2023-2024", "yield_amount": "18.3 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Highland Dairy Farm",
        "location": "Kilimanjaro",
        "size": "15 acres",
        "topography": "Rolling hills",
        "coordinates": json.dumps({"lat": "-3.0674", "lng": "37.3556"}),
        "soil_params": json.dumps({
            "moisture": "75%",
            "organic_carbon": "3.2%",
            "texture": "Clay Loam",
            "ph": "7.2",
            "ec": "0.45 dS/m",
            "salinity": "Medium",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: Medium, K: Medium"
        }),
        "crop_history": json.dumps([
            {"crop": "Alfalfa", "season": "2023-2024", "yield_amount": "22.5 tons"},
            {"crop": "Corn Silage", "season": "2023-2024", "yield_amount": "35.8 tons"},
            {"crop": "Pasture Grass", "season": "2023-2024", "yield_amount": "18.2 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Coastal Vegetable Farm",
        "location": "Dar es Salaam",
        "size": "8 acres",
        "topography": "Flat coastal plain",
        "coordinates": json.dumps({"lat": "-6.8230", "lng": "39.2695"}),
        "soil_params": json.dumps({
            "moisture": "55%",
            "organic_carbon": "2.1%",
            "texture": "Silty Clay",
            "ph": "6.8",
            "ec": "0.38 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: High, K: Low"
        }),
        "crop_history": json.dumps([
            {"crop": "Lettuce", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Cabbage", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Carrots", "season": "2023-2024", "yield_amount": "15.8 tons"},
            {"crop": "Onions", "season": "2023-2024", "yield_amount": "9.2 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mbeya Highlands Farm",
        "location": "Mbeya",
        "size": "35 acres",
        "topography": "Highland plateau",
        "coordinates": json.dumps({"lat": "-8.9074", "lng": "33.4608"}),
        "soil_params": json.dumps({
            "moisture": "65%",
            "organic_carbon": "2.8%",
            "texture": "Volcanic Loam",
            "ph": "6.2",
            "ec": "0.32 dS/m",
            "salinity": "Low",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: High, K: Medium"
        }),
        "crop_history": json.dumps([
            {"crop": "Irish Potato", "season": "2023-2024", "yield_amount": "28.5 tons"},
            {"crop": "Wheat", "season": "2023-2024", "yield_amount": "12.8 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "4.2 tons"}
        ])
    }
]

def add_test_farms():
    """Add test farms to the database"""
    print("Adding test farms to database...")
    
    # First, get a user ID
    with engine.connect() as conn:
        result = conn.execute(text("SELECT id FROM users LIMIT 1"))
        user = result.fetchone()
        
        if not user:
            print("No users found in database. Please create a user first.")
            return
        
        user_id = user[0]
        print(f"Using user ID: {user_id}")
        
        # Add farms
        for farm in TANZANIA_FARMS:
            # Check if farm already exists
            result = conn.execute(
                text("SELECT id FROM farms WHERE name = :name AND user_id = :user_id"),
                {"name": farm["name"], "user_id": user_id}
            )
            
            if result.fetchone():
                print(f"Farm '{farm['name']}' already exists, skipping...")
                continue
            
            # Insert farm
            conn.execute(
                text("""
                    INSERT INTO farms (id, user_id, name, location, size, topography, 
                                     coordinates, soil_params, crop_history, created_at, updated_at)
                    VALUES (:id, :user_id, :name, :location, :size, :topography,
                           :coordinates, :soil_params, :crop_history, :created_at, :updated_at)
                """),
                {
                    "id": farm["id"],
                    "user_id": user_id,
                    "name": farm["name"],
                    "location": farm["location"],
                    "size": farm["size"],
                    "topography": farm["topography"],
                    "coordinates": farm["coordinates"],
                    "soil_params": farm["soil_params"],
                    "crop_history": farm["crop_history"],
                    "created_at": datetime.now(),
                    "updated_at": datetime.now()
                }
            )
            print(f"Added farm: {farm['name']} in {farm['location']}")
        
        conn.commit()
        print("Test farms added successfully!")

if __name__ == "__main__":
    add_test_farms() 
 
"""
Simple script to add test farm data
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
from datetime import datetime
import uuid
import json

# Database connection
DATABASE_URL = "sqlite:///./ecofy.db"
engine = create_engine(DATABASE_URL)

# Tanzania-specific farm data
TANZANIA_FARMS = [
    {
        "id": str(uuid.uuid4()),
        "name": "Green Valley Farm",
        "location": "Arusha",
        "size": "25 acres",
        "topography": "Flat to gently undulating",
        "coordinates": json.dumps({"lat": "-3.3731", "lng": "36.6822"}),
        "soil_params": json.dumps({
            "moisture": "60%",
            "organic_carbon": "2.5%",
            "texture": "Loamy",
            "ph": "6.5",
            "ec": "0.35 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Low, K: High"
        }),
        "crop_history": json.dumps([
            {"crop": "Maize", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "2.3 tons"},
            {"crop": "Tomatoes", "season": "2023-2024", "yield_amount": "15.2 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Sunrise Agricultural Estate",
        "location": "Morogoro",
        "size": "50 acres",
        "topography": "Gently sloping",
        "coordinates": json.dumps({"lat": "-6.8235", "lng": "37.6822"}),
        "soil_params": json.dumps({
            "moisture": "45%",
            "organic_carbon": "1.8%",
            "texture": "Sandy Loam",
            "ph": "5.8",
            "ec": "0.28 dS/m",
            "salinity": "Very Low",
            "water_holding": "Low",
            "organic_matter": "Low",
            "npk": "N: Low, P: Medium, K: Medium"
        }),
        "crop_history": json.dumps([
            {"crop": "Rice", "season": "2023-2024", "yield_amount": "12.5 tons"},
            {"crop": "Cassava", "season": "2023-2024", "yield_amount": "45.8 tons"},
            {"crop": "Sweet Potatoes", "season": "2023-2024", "yield_amount": "18.3 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Highland Dairy Farm",
        "location": "Kilimanjaro",
        "size": "15 acres",
        "topography": "Rolling hills",
        "coordinates": json.dumps({"lat": "-3.0674", "lng": "37.3556"}),
        "soil_params": json.dumps({
            "moisture": "75%",
            "organic_carbon": "3.2%",
            "texture": "Clay Loam",
            "ph": "7.2",
            "ec": "0.45 dS/m",
            "salinity": "Medium",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: Medium, K: Medium"
        }),
        "crop_history": json.dumps([
            {"crop": "Alfalfa", "season": "2023-2024", "yield_amount": "22.5 tons"},
            {"crop": "Corn Silage", "season": "2023-2024", "yield_amount": "35.8 tons"},
            {"crop": "Pasture Grass", "season": "2023-2024", "yield_amount": "18.2 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Coastal Vegetable Farm",
        "location": "Dar es Salaam",
        "size": "8 acres",
        "topography": "Flat coastal plain",
        "coordinates": json.dumps({"lat": "-6.8230", "lng": "39.2695"}),
        "soil_params": json.dumps({
            "moisture": "55%",
            "organic_carbon": "2.1%",
            "texture": "Silty Clay",
            "ph": "6.8",
            "ec": "0.38 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: High, K: Low"
        }),
        "crop_history": json.dumps([
            {"crop": "Lettuce", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Cabbage", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Carrots", "season": "2023-2024", "yield_amount": "15.8 tons"},
            {"crop": "Onions", "season": "2023-2024", "yield_amount": "9.2 tons"}
        ])
    },
    {
        "id": str(uuid.uuid4()),
        "name": "Mbeya Highlands Farm",
        "location": "Mbeya",
        "size": "35 acres",
        "topography": "Highland plateau",
        "coordinates": json.dumps({"lat": "-8.9074", "lng": "33.4608"}),
        "soil_params": json.dumps({
            "moisture": "65%",
            "organic_carbon": "2.8%",
            "texture": "Volcanic Loam",
            "ph": "6.2",
            "ec": "0.32 dS/m",
            "salinity": "Low",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: High, K: Medium"
        }),
        "crop_history": json.dumps([
            {"crop": "Irish Potato", "season": "2023-2024", "yield_amount": "28.5 tons"},
            {"crop": "Wheat", "season": "2023-2024", "yield_amount": "12.8 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "4.2 tons"}
        ])
    }
]

def add_test_farms():
    """Add test farms to the database"""
    print("Adding test farms to database...")
    
    # First, get a user ID
    with engine.connect() as conn:
        result = conn.execute(text("SELECT id FROM users LIMIT 1"))
        user = result.fetchone()
        
        if not user:
            print("No users found in database. Please create a user first.")
            return
        
        user_id = user[0]
        print(f"Using user ID: {user_id}")
        
        # Add farms
        for farm in TANZANIA_FARMS:
            # Check if farm already exists
            result = conn.execute(
                text("SELECT id FROM farms WHERE name = :name AND user_id = :user_id"),
                {"name": farm["name"], "user_id": user_id}
            )
            
            if result.fetchone():
                print(f"Farm '{farm['name']}' already exists, skipping...")
                continue
            
            # Insert farm
            conn.execute(
                text("""
                    INSERT INTO farms (id, user_id, name, location, size, topography, 
                                     coordinates, soil_params, crop_history, created_at, updated_at)
                    VALUES (:id, :user_id, :name, :location, :size, :topography,
                           :coordinates, :soil_params, :crop_history, :created_at, :updated_at)
                """),
                {
                    "id": farm["id"],
                    "user_id": user_id,
                    "name": farm["name"],
                    "location": farm["location"],
                    "size": farm["size"],
                    "topography": farm["topography"],
                    "coordinates": farm["coordinates"],
                    "soil_params": farm["soil_params"],
                    "crop_history": farm["crop_history"],
                    "created_at": datetime.now(),
                    "updated_at": datetime.now()
                }
            )
            print(f"Added farm: {farm['name']} in {farm['location']}")
        
        conn.commit()
        print("Test farms added successfully!")

if __name__ == "__main__":
    add_test_farms() 
 