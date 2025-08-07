#!/usr/bin/env python3
"""
Farm data seeding script for Ecofy backend
Populates the database with Tanzania-specific farm data
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.database import get_db, engine, Base
from app.models.farm import Farm
from app.models.user import User
from datetime import datetime
import uuid
import random

# Tanzania-specific farm data
TANZANIA_FARMS = [
    {
        "name": "Green Valley Farm",
        "location": "Arusha",
        "size": "25 acres",
        "topography": "Flat to gently undulating",
        "coordinates": {"lat": "-3.3731", "lng": "36.6822"},
        "soil_params": {
            "moisture": "60%",
            "organic_carbon": "2.5%",
            "texture": "Loamy",
            "ph": "6.5",
            "ec": "0.35 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Low, K: High"
        },
        "crop_history": [
            {"crop": "Maize", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "2.3 tons"},
            {"crop": "Tomatoes", "season": "2023-2024", "yield_amount": "15.2 tons"}
        ]
    },
    {
        "name": "Sunrise Agricultural Estate",
        "location": "Morogoro",
        "size": "50 acres",
        "topography": "Gently sloping",
        "coordinates": {"lat": "-6.8235", "lng": "37.6822"},
        "soil_params": {
            "moisture": "45%",
            "organic_carbon": "1.8%",
            "texture": "Sandy Loam",
            "ph": "5.8",
            "ec": "0.28 dS/m",
            "salinity": "Very Low",
            "water_holding": "Low",
            "organic_matter": "Low",
            "npk": "N: Low, P: Medium, K: Medium"
        },
        "crop_history": [
            {"crop": "Rice", "season": "2023-2024", "yield_amount": "12.5 tons"},
            {"crop": "Cassava", "season": "2023-2024", "yield_amount": "45.8 tons"},
            {"crop": "Sweet Potatoes", "season": "2023-2024", "yield_amount": "18.3 tons"}
        ]
    },
    {
        "name": "Highland Dairy Farm",
        "location": "Kilimanjaro",
        "size": "15 acres",
        "topography": "Rolling hills",
        "coordinates": {"lat": "-3.0674", "lng": "37.3556"},
        "soil_params": {
            "moisture": "75%",
            "organic_carbon": "3.2%",
            "texture": "Clay Loam",
            "ph": "7.2",
            "ec": "0.45 dS/m",
            "salinity": "Medium",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: Medium, K: Medium"
        },
        "crop_history": [
            {"crop": "Alfalfa", "season": "2023-2024", "yield_amount": "22.5 tons"},
            {"crop": "Corn Silage", "season": "2023-2024", "yield_amount": "35.8 tons"},
            {"crop": "Pasture Grass", "season": "2023-2024", "yield_amount": "18.2 tons"}
        ]
    },
    {
        "name": "Coastal Vegetable Farm",
        "location": "Dar es Salaam",
        "size": "8 acres",
        "topography": "Flat coastal plain",
        "coordinates": {"lat": "-6.8230", "lng": "39.2695"},
        "soil_params": {
            "moisture": "55%",
            "organic_carbon": "2.1%",
            "texture": "Silty Clay",
            "ph": "6.8",
            "ec": "0.38 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: High, K: Low"
        },
        "crop_history": [
            {"crop": "Lettuce", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Cabbage", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Carrots", "season": "2023-2024", "yield_amount": "15.8 tons"},
            {"crop": "Onions", "season": "2023-2024", "yield_amount": "9.2 tons"}
        ]
    },
    {
        "name": "Mbeya Highlands Farm",
        "location": "Mbeya",
        "size": "35 acres",
        "topography": "Highland plateau",
        "coordinates": {"lat": "-8.9074", "lng": "33.4608"},
        "soil_params": {
            "moisture": "65%",
            "organic_carbon": "2.8%",
            "texture": "Volcanic Loam",
            "ph": "6.2",
            "ec": "0.32 dS/m",
            "salinity": "Low",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: High, K: Medium"
        },
        "crop_history": [
            {"crop": "Irish Potato", "season": "2023-2024", "yield_amount": "28.5 tons"},
            {"crop": "Wheat", "season": "2023-2024", "yield_amount": "12.8 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "4.2 tons"}
        ]
    },
    {
        "name": "Mwanza Lake Farm",
        "location": "Mwanza",
        "size": "20 acres",
        "topography": "Lake shore plains",
        "coordinates": {"lat": "-2.5167", "lng": "32.9000"},
        "soil_params": {
            "moisture": "70%",
            "organic_carbon": "2.3%",
            "texture": "Silty Loam",
            "ph": "6.8",
            "ec": "0.40 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Medium, K: High"
        },
        "crop_history": [
            {"crop": "Rice", "season": "2023-2024", "yield_amount": "18.5 tons"},
            {"crop": "Maize", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Cassava", "season": "2023-2024", "yield_amount": "25.8 tons"}
        ]
    },
    {
        "name": "Iringa Coffee Estate",
        "location": "Iringa",
        "size": "12 acres",
        "topography": "Mountain slopes",
        "coordinates": {"lat": "-7.7667", "lng": "35.7000"},
        "soil_params": {
            "moisture": "60%",
            "organic_carbon": "3.5%",
            "texture": "Red Clay",
            "ph": "5.8",
            "ec": "0.25 dS/m",
            "salinity": "Very Low",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: Medium, P: Low, K: High"
        },
        "crop_history": [
            {"crop": "Coffee", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Tea", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Bananas", "season": "2023-2024", "yield_amount": "15.8 tons"}
        ]
    },
    {
        "name": "Dodoma Grain Farm",
        "location": "Dodoma",
        "size": "40 acres",
        "topography": "Semi-arid plains",
        "coordinates": {"lat": "-6.1730", "lng": "35.7419"},
        "soil_params": {
            "moisture": "35%",
            "organic_carbon": "1.2%",
            "texture": "Sandy Clay",
            "ph": "7.5",
            "ec": "0.45 dS/m",
            "salinity": "Medium",
            "water_holding": "Low",
            "organic_matter": "Low",
            "npk": "N: Low, P: Low, K: Medium"
        },
        "crop_history": [
            {"crop": "Sorghum", "season": "2023-2024", "yield_amount": "18.5 tons"},
            {"crop": "Millet", "season": "2023-2024", "yield_amount": "8.3 tons"},
            {"crop": "Sunflower", "season": "2023-2024", "yield_amount": "12.8 tons"}
        ]
    }
]

def seed_farms(db: Session, user_id: str):
    """Seed farms for a specific user"""
    print(f"Seeding farms for user {user_id}...")
    
    for farm_data in TANZANIA_FARMS:
        # Check if farm already exists
        existing_farm = db.query(Farm).filter(
            Farm.name == farm_data["name"],
            Farm.user_id == user_id
        ).first()
        
        if existing_farm:
            print(f"Farm '{farm_data['name']}' already exists, skipping...")
            continue
        
        farm = Farm(
            id=str(uuid.uuid4()),
            user_id=user_id,
            name=farm_data["name"],
            location=farm_data["location"],
            size=farm_data["size"],
            topography=farm_data["topography"],
            coordinates=farm_data["coordinates"],
            soil_params=farm_data["soil_params"],
            crop_history=farm_data["crop_history"],
            created_at=datetime.now(),
            updated_at=datetime.now()
        )
        
        db.add(farm)
        print(f"Added farm: {farm_data['name']} in {farm_data['location']}")
    
    db.commit()
    print("Farm seeding completed!")

def main():
    """Main function to seed farms"""
    print("Starting farm data seeding...")
    
    # Create database tables
    Base.metadata.create_all(bind=engine)
    
    # Get database session
    db = next(get_db())
    
    try:
        # Get the first user (or create one if needed)
        user = db.query(User).first()
        if not user:
            print("No users found in database. Please create a user first.")
            return
        
        # Seed farms for the user
        seed_farms(db, user.id)
        
    except Exception as e:
        print(f"Error seeding farms: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    main() 
 
"""
Farm data seeding script for Ecofy backend
Populates the database with Tanzania-specific farm data
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.database import get_db, engine, Base
from app.models.farm import Farm
from app.models.user import User
from datetime import datetime
import uuid
import random

# Tanzania-specific farm data
TANZANIA_FARMS = [
    {
        "name": "Green Valley Farm",
        "location": "Arusha",
        "size": "25 acres",
        "topography": "Flat to gently undulating",
        "coordinates": {"lat": "-3.3731", "lng": "36.6822"},
        "soil_params": {
            "moisture": "60%",
            "organic_carbon": "2.5%",
            "texture": "Loamy",
            "ph": "6.5",
            "ec": "0.35 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Low, K: High"
        },
        "crop_history": [
            {"crop": "Maize", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "2.3 tons"},
            {"crop": "Tomatoes", "season": "2023-2024", "yield_amount": "15.2 tons"}
        ]
    },
    {
        "name": "Sunrise Agricultural Estate",
        "location": "Morogoro",
        "size": "50 acres",
        "topography": "Gently sloping",
        "coordinates": {"lat": "-6.8235", "lng": "37.6822"},
        "soil_params": {
            "moisture": "45%",
            "organic_carbon": "1.8%",
            "texture": "Sandy Loam",
            "ph": "5.8",
            "ec": "0.28 dS/m",
            "salinity": "Very Low",
            "water_holding": "Low",
            "organic_matter": "Low",
            "npk": "N: Low, P: Medium, K: Medium"
        },
        "crop_history": [
            {"crop": "Rice", "season": "2023-2024", "yield_amount": "12.5 tons"},
            {"crop": "Cassava", "season": "2023-2024", "yield_amount": "45.8 tons"},
            {"crop": "Sweet Potatoes", "season": "2023-2024", "yield_amount": "18.3 tons"}
        ]
    },
    {
        "name": "Highland Dairy Farm",
        "location": "Kilimanjaro",
        "size": "15 acres",
        "topography": "Rolling hills",
        "coordinates": {"lat": "-3.0674", "lng": "37.3556"},
        "soil_params": {
            "moisture": "75%",
            "organic_carbon": "3.2%",
            "texture": "Clay Loam",
            "ph": "7.2",
            "ec": "0.45 dS/m",
            "salinity": "Medium",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: Medium, K: Medium"
        },
        "crop_history": [
            {"crop": "Alfalfa", "season": "2023-2024", "yield_amount": "22.5 tons"},
            {"crop": "Corn Silage", "season": "2023-2024", "yield_amount": "35.8 tons"},
            {"crop": "Pasture Grass", "season": "2023-2024", "yield_amount": "18.2 tons"}
        ]
    },
    {
        "name": "Coastal Vegetable Farm",
        "location": "Dar es Salaam",
        "size": "8 acres",
        "topography": "Flat coastal plain",
        "coordinates": {"lat": "-6.8230", "lng": "39.2695"},
        "soil_params": {
            "moisture": "55%",
            "organic_carbon": "2.1%",
            "texture": "Silty Clay",
            "ph": "6.8",
            "ec": "0.38 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: High, K: Low"
        },
        "crop_history": [
            {"crop": "Lettuce", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Cabbage", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Carrots", "season": "2023-2024", "yield_amount": "15.8 tons"},
            {"crop": "Onions", "season": "2023-2024", "yield_amount": "9.2 tons"}
        ]
    },
    {
        "name": "Mbeya Highlands Farm",
        "location": "Mbeya",
        "size": "35 acres",
        "topography": "Highland plateau",
        "coordinates": {"lat": "-8.9074", "lng": "33.4608"},
        "soil_params": {
            "moisture": "65%",
            "organic_carbon": "2.8%",
            "texture": "Volcanic Loam",
            "ph": "6.2",
            "ec": "0.32 dS/m",
            "salinity": "Low",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: High, P: High, K: Medium"
        },
        "crop_history": [
            {"crop": "Irish Potato", "season": "2023-2024", "yield_amount": "28.5 tons"},
            {"crop": "Wheat", "season": "2023-2024", "yield_amount": "12.8 tons"},
            {"crop": "Beans", "season": "2023-2024", "yield_amount": "4.2 tons"}
        ]
    },
    {
        "name": "Mwanza Lake Farm",
        "location": "Mwanza",
        "size": "20 acres",
        "topography": "Lake shore plains",
        "coordinates": {"lat": "-2.5167", "lng": "32.9000"},
        "soil_params": {
            "moisture": "70%",
            "organic_carbon": "2.3%",
            "texture": "Silty Loam",
            "ph": "6.8",
            "ec": "0.40 dS/m",
            "salinity": "Low",
            "water_holding": "Medium",
            "organic_matter": "Medium",
            "npk": "N: Medium, P: Medium, K: High"
        },
        "crop_history": [
            {"crop": "Rice", "season": "2023-2024", "yield_amount": "18.5 tons"},
            {"crop": "Maize", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Cassava", "season": "2023-2024", "yield_amount": "25.8 tons"}
        ]
    },
    {
        "name": "Iringa Coffee Estate",
        "location": "Iringa",
        "size": "12 acres",
        "topography": "Mountain slopes",
        "coordinates": {"lat": "-7.7667", "lng": "35.7000"},
        "soil_params": {
            "moisture": "60%",
            "organic_carbon": "3.5%",
            "texture": "Red Clay",
            "ph": "5.8",
            "ec": "0.25 dS/m",
            "salinity": "Very Low",
            "water_holding": "High",
            "organic_matter": "High",
            "npk": "N: Medium, P: Low, K: High"
        },
        "crop_history": [
            {"crop": "Coffee", "season": "2023-2024", "yield_amount": "8.5 tons"},
            {"crop": "Tea", "season": "2023-2024", "yield_amount": "12.3 tons"},
            {"crop": "Bananas", "season": "2023-2024", "yield_amount": "15.8 tons"}
        ]
    },
    {
        "name": "Dodoma Grain Farm",
        "location": "Dodoma",
        "size": "40 acres",
        "topography": "Semi-arid plains",
        "coordinates": {"lat": "-6.1730", "lng": "35.7419"},
        "soil_params": {
            "moisture": "35%",
            "organic_carbon": "1.2%",
            "texture": "Sandy Clay",
            "ph": "7.5",
            "ec": "0.45 dS/m",
            "salinity": "Medium",
            "water_holding": "Low",
            "organic_matter": "Low",
            "npk": "N: Low, P: Low, K: Medium"
        },
        "crop_history": [
            {"crop": "Sorghum", "season": "2023-2024", "yield_amount": "18.5 tons"},
            {"crop": "Millet", "season": "2023-2024", "yield_amount": "8.3 tons"},
            {"crop": "Sunflower", "season": "2023-2024", "yield_amount": "12.8 tons"}
        ]
    }
]

def seed_farms(db: Session, user_id: str):
    """Seed farms for a specific user"""
    print(f"Seeding farms for user {user_id}...")
    
    for farm_data in TANZANIA_FARMS:
        # Check if farm already exists
        existing_farm = db.query(Farm).filter(
            Farm.name == farm_data["name"],
            Farm.user_id == user_id
        ).first()
        
        if existing_farm:
            print(f"Farm '{farm_data['name']}' already exists, skipping...")
            continue
        
        farm = Farm(
            id=str(uuid.uuid4()),
            user_id=user_id,
            name=farm_data["name"],
            location=farm_data["location"],
            size=farm_data["size"],
            topography=farm_data["topography"],
            coordinates=farm_data["coordinates"],
            soil_params=farm_data["soil_params"],
            crop_history=farm_data["crop_history"],
            created_at=datetime.now(),
            updated_at=datetime.now()
        )
        
        db.add(farm)
        print(f"Added farm: {farm_data['name']} in {farm_data['location']}")
    
    db.commit()
    print("Farm seeding completed!")

def main():
    """Main function to seed farms"""
    print("Starting farm data seeding...")
    
    # Create database tables
    Base.metadata.create_all(bind=engine)
    
    # Get database session
    db = next(get_db())
    
    try:
        # Get the first user (or create one if needed)
        user = db.query(User).first()
        if not user:
            print("No users found in database. Please create a user first.")
            return
        
        # Seed farms for the user
        seed_farms(db, user.id)
        
    except Exception as e:
        print(f"Error seeding farms: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    main() 
 