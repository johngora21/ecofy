#!/usr/bin/env python3
"""
Test MongoDB connection and add initial data
"""
import asyncio
import sys
import os
from datetime import datetime
import uuid
import json

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def test_mongodb_connection():
    """Test MongoDB connection and add initial data"""
    try:
        print("Connecting to MongoDB...")
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # Create a test user
        test_user = {
            "_id": str(uuid.uuid4()),
            "email": "test@ecofy.com",
            "full_name": "Test User",
            "phone_number": "+255123456789",
            "location": "Arusha, Tanzania",
            "hashed_password": "$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KqKqKq",  # password: test123
            "role": "farmer",
            "preferred_language": "en",
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow(),
            "is_active": True
        }
        
        # Check if user already exists
        existing_user = await db.users.find_one({"email": test_user["email"]})
        if existing_user:
            print("✅ Test user already exists")
            user_id = existing_user["_id"]
        else:
            # Insert test user
            result = await db.users.insert_one(test_user)
            user_id = result.inserted_id
            print("✅ Created test user")
        
        # Create test farms
        test_farms = [
            {
                "user_id": user_id,
                "name": "Green Valley Farm",
                "location": "Arusha",
                "size": "25 acres",
                "topography": "Flat to gently undulating",
                "coordinates": {"lat": -3.3731, "lng": 36.6822},
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
                "user_id": user_id,
                "name": "Kilimanjaro Highland Farm",
                "location": "Kilimanjaro",
                "size": "15 acres",
                "topography": "Hilly with terraces",
                "coordinates": {"lat": -3.0758, "lng": 37.3533},
                "soil_params": {
                    "moisture": "75%",
                    "organic_carbon": "3.2%",
                    "texture": "Clay loam",
                    "ph": "6.8",
                    "ec": "0.28 dS/m",
                    "salinity": "Very Low",
                    "water_holding": "High",
                    "organic_matter": "High",
                    "npk": "N: High, P: Medium, K: Medium"
                },
                "crop_history": [
                    {"crop": "Coffee", "season": "2023-2024", "yield_amount": "2.1 tons"},
                    {"crop": "Bananas", "season": "2023-2024", "yield_amount": "12.5 tons"},
                    {"crop": "Avocados", "season": "2023-2024", "yield_amount": "8.3 tons"}
                ]
            },
            {
                "user_id": user_id,
                "name": "Morogoro Plains Farm",
                "location": "Morogoro",
                "size": "40 acres",
                "topography": "Flat plains",
                "coordinates": {"lat": -6.8235, "lng": 37.6612},
                "soil_params": {
                    "moisture": "45%",
                    "organic_carbon": "1.8%",
                    "texture": "Sandy loam",
                    "ph": "6.2",
                    "ec": "0.42 dS/m",
                    "salinity": "Medium",
                    "water_holding": "Low",
                    "organic_matter": "Low",
                    "npk": "N: Low, P: Medium, K: Low"
                },
                "crop_history": [
                    {"crop": "Rice", "season": "2023-2024", "yield_amount": "18.5 tons"},
                    {"crop": "Sugarcane", "season": "2023-2024", "yield_amount": "45.2 tons"}
                ]
            },
            {
                "user_id": user_id,
                "name": "Dodoma Central Farm",
                "location": "Dodoma",
                "size": "30 acres",
                "topography": "Semi-arid plains",
                "coordinates": {"lat": -6.1730, "lng": 35.7420},
                "soil_params": {
                    "moisture": "35%",
                    "organic_carbon": "1.2%",
                    "texture": "Sandy",
                    "ph": "7.1",
                    "ec": "0.55 dS/m",
                    "salinity": "High",
                    "water_holding": "Very Low",
                    "organic_matter": "Very Low",
                    "npk": "N: Very Low, P: Low, K: Medium"
                },
                "crop_history": [
                    {"crop": "Sorghum", "season": "2023-2024", "yield_amount": "6.8 tons"},
                    {"crop": "Millet", "season": "2023-2024", "yield_amount": "4.2 tons"},
                    {"crop": "Sunflower", "season": "2023-2024", "yield_amount": "3.5 tons"}
                ]
            },
            {
                "user_id": user_id,
                "name": "Mwanza Lake Farm",
                "location": "Mwanza",
                "size": "20 acres",
                "topography": "Lakeside with gentle slopes",
                "coordinates": {"lat": -2.5167, "lng": 32.9000},
                "soil_params": {
                    "moisture": "80%",
                    "organic_carbon": "2.8%",
                    "texture": "Clay",
                    "ph": "6.9",
                    "ec": "0.32 dS/m",
                    "salinity": "Low",
                    "water_holding": "High",
                    "organic_matter": "Medium",
                    "npk": "N: Medium, P: High, K: Medium"
                },
                "crop_history": [
                    {"crop": "Cassava", "season": "2023-2024", "yield_amount": "22.5 tons"},
                    {"crop": "Sweet Potatoes", "season": "2023-2024", "yield_amount": "18.7 tons"},
                    {"crop": "Yams", "season": "2023-2024", "yield_amount": "12.3 tons"}
                ]
            }
        ]
        
        # Check if farms already exist
        existing_farms = await db.farms.find({"user_id": user_id}).to_list(length=None)
        if existing_farms:
            print(f"✅ Found {len(existing_farms)} existing farms")
        else:
            # Insert test farms
            result = await db.farms.insert_many(test_farms)
            print(f"✅ Created {len(result.inserted_ids)} test farms")
        
        # List all collections
        collections = await db.list_collection_names()
        print(f"📊 Database collections: {collections}")
        
        # Count documents in each collection
        for collection_name in collections:
            count = await db[collection_name].count_documents({})
            print(f"   - {collection_name}: {count} documents")
        
        print("\n🎉 MongoDB setup completed successfully!")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False
    
    finally:
        client.close()
    
    return True

if __name__ == "__main__":
    asyncio.run(test_mongodb_connection()) 
 
"""
Test MongoDB connection and add initial data
"""
import asyncio
import sys
import os
from datetime import datetime
import uuid
import json

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def test_mongodb_connection():
    """Test MongoDB connection and add initial data"""
    try:
        print("Connecting to MongoDB...")
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # Create a test user
        test_user = {
            "_id": str(uuid.uuid4()),
            "email": "test@ecofy.com",
            "full_name": "Test User",
            "phone_number": "+255123456789",
            "location": "Arusha, Tanzania",
            "hashed_password": "$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KqKqKq",  # password: test123
            "role": "farmer",
            "preferred_language": "en",
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow(),
            "is_active": True
        }
        
        # Check if user already exists
        existing_user = await db.users.find_one({"email": test_user["email"]})
        if existing_user:
            print("✅ Test user already exists")
            user_id = existing_user["_id"]
        else:
            # Insert test user
            result = await db.users.insert_one(test_user)
            user_id = result.inserted_id
            print("✅ Created test user")
        
        # Create test farms
        test_farms = [
            {
                "user_id": user_id,
                "name": "Green Valley Farm",
                "location": "Arusha",
                "size": "25 acres",
                "topography": "Flat to gently undulating",
                "coordinates": {"lat": -3.3731, "lng": 36.6822},
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
                "user_id": user_id,
                "name": "Kilimanjaro Highland Farm",
                "location": "Kilimanjaro",
                "size": "15 acres",
                "topography": "Hilly with terraces",
                "coordinates": {"lat": -3.0758, "lng": 37.3533},
                "soil_params": {
                    "moisture": "75%",
                    "organic_carbon": "3.2%",
                    "texture": "Clay loam",
                    "ph": "6.8",
                    "ec": "0.28 dS/m",
                    "salinity": "Very Low",
                    "water_holding": "High",
                    "organic_matter": "High",
                    "npk": "N: High, P: Medium, K: Medium"
                },
                "crop_history": [
                    {"crop": "Coffee", "season": "2023-2024", "yield_amount": "2.1 tons"},
                    {"crop": "Bananas", "season": "2023-2024", "yield_amount": "12.5 tons"},
                    {"crop": "Avocados", "season": "2023-2024", "yield_amount": "8.3 tons"}
                ]
            },
            {
                "user_id": user_id,
                "name": "Morogoro Plains Farm",
                "location": "Morogoro",
                "size": "40 acres",
                "topography": "Flat plains",
                "coordinates": {"lat": -6.8235, "lng": 37.6612},
                "soil_params": {
                    "moisture": "45%",
                    "organic_carbon": "1.8%",
                    "texture": "Sandy loam",
                    "ph": "6.2",
                    "ec": "0.42 dS/m",
                    "salinity": "Medium",
                    "water_holding": "Low",
                    "organic_matter": "Low",
                    "npk": "N: Low, P: Medium, K: Low"
                },
                "crop_history": [
                    {"crop": "Rice", "season": "2023-2024", "yield_amount": "18.5 tons"},
                    {"crop": "Sugarcane", "season": "2023-2024", "yield_amount": "45.2 tons"}
                ]
            },
            {
                "user_id": user_id,
                "name": "Dodoma Central Farm",
                "location": "Dodoma",
                "size": "30 acres",
                "topography": "Semi-arid plains",
                "coordinates": {"lat": -6.1730, "lng": 35.7420},
                "soil_params": {
                    "moisture": "35%",
                    "organic_carbon": "1.2%",
                    "texture": "Sandy",
                    "ph": "7.1",
                    "ec": "0.55 dS/m",
                    "salinity": "High",
                    "water_holding": "Very Low",
                    "organic_matter": "Very Low",
                    "npk": "N: Very Low, P: Low, K: Medium"
                },
                "crop_history": [
                    {"crop": "Sorghum", "season": "2023-2024", "yield_amount": "6.8 tons"},
                    {"crop": "Millet", "season": "2023-2024", "yield_amount": "4.2 tons"},
                    {"crop": "Sunflower", "season": "2023-2024", "yield_amount": "3.5 tons"}
                ]
            },
            {
                "user_id": user_id,
                "name": "Mwanza Lake Farm",
                "location": "Mwanza",
                "size": "20 acres",
                "topography": "Lakeside with gentle slopes",
                "coordinates": {"lat": -2.5167, "lng": 32.9000},
                "soil_params": {
                    "moisture": "80%",
                    "organic_carbon": "2.8%",
                    "texture": "Clay",
                    "ph": "6.9",
                    "ec": "0.32 dS/m",
                    "salinity": "Low",
                    "water_holding": "High",
                    "organic_matter": "Medium",
                    "npk": "N: Medium, P: High, K: Medium"
                },
                "crop_history": [
                    {"crop": "Cassava", "season": "2023-2024", "yield_amount": "22.5 tons"},
                    {"crop": "Sweet Potatoes", "season": "2023-2024", "yield_amount": "18.7 tons"},
                    {"crop": "Yams", "season": "2023-2024", "yield_amount": "12.3 tons"}
                ]
            }
        ]
        
        # Check if farms already exist
        existing_farms = await db.farms.find({"user_id": user_id}).to_list(length=None)
        if existing_farms:
            print(f"✅ Found {len(existing_farms)} existing farms")
        else:
            # Insert test farms
            result = await db.farms.insert_many(test_farms)
            print(f"✅ Created {len(result.inserted_ids)} test farms")
        
        # List all collections
        collections = await db.list_collection_names()
        print(f"📊 Database collections: {collections}")
        
        # Count documents in each collection
        for collection_name in collections:
            count = await db[collection_name].count_documents({})
            print(f"   - {collection_name}: {count} documents")
        
        print("\n🎉 MongoDB setup completed successfully!")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False
    
    finally:
        client.close()
    
    return True

if __name__ == "__main__":
    asyncio.run(test_mongodb_connection()) 
 