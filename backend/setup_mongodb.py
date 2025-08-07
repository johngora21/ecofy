#!/usr/bin/env python3
"""
Setup script for MongoDB database - EXACT collections for Flutter app
"""
import sys
import os
from datetime import datetime
import uuid
import json

# Add the backend directory to the Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from app.core.config import settings

def setup_database():
    """Set up MongoDB database with EXACT collections for Flutter app"""
    print("Setting up MongoDB database for Flutter app...")
    
    # Connect to MongoDB
    client = MongoClient(settings.MONGODB_URL, server_api=ServerApi('1'))
    db = client[settings.MONGODB_DATABASE]
    
    try:
        # DROP ALL EXISTING COLLECTIONS FIRST
        print("🗑️  Dropping all existing collections...")
        existing_collections = db.list_collection_names()
        for collection_name in existing_collections:
            db.drop_collection(collection_name)
            print(f"❌ Dropped collection: {collection_name}")
        
        # Create ONLY the EXACT collections for Flutter app
        collections = [
            'users',           # User profiles and authentication
            'farms',           # Farm management (Add/Edit/View farms)
            'products',        # Marketplace products (crops, livestock, poultry, fisheries, seeds, fertilizers, pesticides, equipment)
            'orders',          # Order tracking and management
            'cart_items',      # Shopping cart functionality
            'chat_sessions',   # AI chatbot sessions
            'chat_messages',   # Individual chat messages
            'notifications',   # User notifications
            'resources',       # Tutorials, books, events, business plans
            'market_data',     # Market intelligence data
            'soil_data',       # Soil insights
            'climate_data',    # Climate information
            'crops_data',      # Crop information
            'regions_data',    # Regional data
            'risks_data'       # Risk assessment data
        ]
        
        print("✅ Creating EXACT collections for Flutter app...")
        for collection_name in collections:
            db.create_collection(collection_name)
            print(f"✅ Created collection: {collection_name}")
        
        # Add sample user if not exists
        user_id = str(uuid.uuid4())
        user_doc = {
            "_id": user_id,
            "email": "test@ecofy.com",
            "full_name": "Test Farmer",
            "phone_number": "+255123456789",
            "location": "Arusha, Tanzania",
            "hashed_password": "$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8HqKq6e",  # password: test123
            "role": "farmer",
            "preferred_language": "en",
            "profile_image": None,
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow(),
            "is_active": True
        }
        db.users.insert_one(user_doc)
        print("✅ Created test user: test@ecofy.com (password: test123)")
        
        # Add sample farms if not exists
        existing_farms = db.farms.count_documents({})
        if existing_farms == 0:
            sample_farms = [
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
                    ],
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
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
                    ],
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
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
                        {"crop": "Sugarcane", "season": "2023-2024", "yield_amount": "45.2 tons"},
                        {"crop": "Cassava", "season": "2023-2024", "yield_amount": "22.1 tons"}
                    ],
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            
            db.farms.insert_many(sample_farms)
            print(f"Created {len(sample_farms)} sample farms")
        else:
            print(f"Found {existing_farms} existing farms")
        
        # Add sample marketplace products
        existing_products = db.products.count_documents({})
        if existing_products == 0:
            sample_products = [
                # Crops
                {
                    "name": "Organic Maize Seeds",
                    "category": "Seeds",
                    "subcategory": "Grains",
                    "price": 2500,
                    "currency": "TZS",
                    "unit": "kg",
                    "quantity": "50kg",
                    "description": "High-yield organic maize seeds suitable for Tanzanian climate",
                    "seller": "Tanzania Seeds Co.",
                    "location": "Arusha",
                    "region": "Arusha",
                    "district": "Arusha City",
                    "grade": "Grade A",
                    "rating": 4.5,
                    "reviews": 23,
                    "views": 156,
                    "featured": True,
                    "inStock": True,
                    "images": ["maize_seeds_1.jpg", "maize_seeds_2.jpg"],
                    "image": "🌽",
                    "originalPrice": 3000,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "NPK Fertilizer",
                    "category": "Fertilizers",
                    "subcategory": "Chemical",
                    "price": 45000,
                    "currency": "TZS",
                    "unit": "bag",
                    "quantity": "25kg",
                    "description": "Balanced NPK fertilizer for all crops",
                    "seller": "Agro Supplies Ltd",
                    "location": "Morogoro",
                    "region": "Morogoro",
                    "district": "Morogoro Municipal",
                    "grade": "Premium",
                    "rating": 4.8,
                    "reviews": 45,
                    "views": 234,
                    "featured": True,
                    "inStock": True,
                    "images": ["npk_fertilizer_1.jpg"],
                    "image": "🌱",
                    "originalPrice": 50000,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Coffee Beans",
                    "category": "Crops",
                    "subcategory": "Cash Crops",
                    "price": 8500,
                    "currency": "TZS",
                    "unit": "kg",
                    "quantity": "100kg",
                    "description": "Premium Arabica coffee beans from Kilimanjaro",
                    "seller": "Kilimanjaro Coffee",
                    "location": "Kilimanjaro",
                    "region": "Kilimanjaro",
                    "district": "Moshi",
                    "grade": "Premium",
                    "rating": 4.9,
                    "reviews": 67,
                    "views": 345,
                    "featured": True,
                    "inStock": True,
                    "images": ["coffee_beans_1.jpg", "coffee_beans_2.jpg"],
                    "image": "☕",
                    "originalPrice": 9000,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Tomato Seeds",
                    "category": "Seeds",
                    "subcategory": "Vegetables",
                    "price": 1200,
                    "currency": "TZS",
                    "unit": "packet",
                    "quantity": "100 seeds",
                    "description": "Hybrid tomato seeds for high yield",
                    "seller": "Green Thumb Seeds",
                    "location": "Dar es Salaam",
                    "region": "Dar es Salaam",
                    "district": "Ilala",
                    "grade": "Grade A",
                    "rating": 4.3,
                    "reviews": 34,
                    "views": 189,
                    "featured": False,
                    "inStock": True,
                    "images": ["tomato_seeds_1.jpg"],
                    "image": "🍅",
                    "originalPrice": 1500,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Organic Pesticide",
                    "category": "Pesticides",
                    "subcategory": "Organic",
                    "price": 3500,
                    "currency": "TZS",
                    "unit": "liter",
                    "quantity": "5 liters",
                    "description": "Natural pesticide safe for organic farming",
                    "seller": "Organic Solutions",
                    "location": "Tanga",
                    "region": "Tanga",
                    "district": "Tanga City",
                    "grade": "Grade B",
                    "rating": 4.1,
                    "reviews": 28,
                    "views": 145,
                    "featured": False,
                    "inStock": True,
                    "images": ["organic_pesticide_1.jpg"],
                    "image": "🌿",
                    "originalPrice": 4000,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Watering Can",
                    "category": "Equipment",
                    "subcategory": "Irrigation",
                    "price": 15000,
                    "currency": "TZS",
                    "unit": "piece",
                    "quantity": "1 piece",
                    "description": "Durable metal watering can for small farms",
                    "seller": "Farm Tools Co.",
                    "location": "Mwanza",
                    "region": "Mwanza",
                    "district": "Ilemela",
                    "grade": "Grade C",
                    "rating": 4.0,
                    "reviews": 19,
                    "views": 98,
                    "featured": False,
                    "inStock": True,
                    "images": ["watering_can_1.jpg"],
                    "image": "🚿",
                    "originalPrice": 18000,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Live Chickens",
                    "category": "Poultry",
                    "subcategory": "Birds",
                    "price": 25000,
                    "currency": "TZS",
                    "unit": "bird",
                    "quantity": "10 birds",
                    "description": "Healthy laying hens ready for farm",
                    "seller": "Poultry Farm Ltd",
                    "location": "Dodoma",
                    "region": "Dodoma",
                    "district": "Dodoma Municipal",
                    "grade": "Grade A",
                    "rating": 4.6,
                    "reviews": 41,
                    "views": 267,
                    "featured": True,
                    "inStock": True,
                    "images": ["chickens_1.jpg", "chickens_2.jpg"],
                    "image": "🐔",
                    "originalPrice": 28000,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Fresh Fish",
                    "category": "Fisheries",
                    "subcategory": "Fresh Water",
                    "price": 8000,
                    "currency": "TZS",
                    "unit": "kg",
                    "quantity": "20kg",
                    "description": "Fresh tilapia from Lake Victoria",
                    "seller": "Lake Fish Co.",
                    "location": "Mwanza",
                    "region": "Mwanza",
                    "district": "Nyamagana",
                    "grade": "Grade A",
                    "rating": 4.7,
                    "reviews": 52,
                    "views": 312,
                    "featured": True,
                    "inStock": True,
                    "images": ["fresh_fish_1.jpg"],
                    "image": "🐟",
                    "originalPrice": 8500,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            
            db.products.insert_many(sample_products)
            print(f"Created {len(sample_products)} sample products")
        else:
            print(f"Found {existing_products} existing products")
        
        # Add sample market data
        sample_market_data = [
            {
                "crop": "Maize",
                "region": "Arusha",
                "current_price": 1200,
                "currency": "TZS",
                "unit": "kg",
                "trend": "increasing",
                "change_percentage": 5.2,
                "date": datetime.utcnow(),
                "created_at": datetime.utcnow()
            },
            {
                "crop": "Rice",
                "region": "Morogoro",
                "current_price": 1800,
                "currency": "TZS",
                "unit": "kg",
                "trend": "stable",
                "change_percentage": 0.0,
                "date": datetime.utcnow(),
                "created_at": datetime.utcnow()
            }
        ]
        
        db.market_data.insert_many(sample_market_data)
        print(f"✅ Created {len(sample_market_data)} sample market data entries")
        
        # Add sample crops data
        sample_crops_data = [
            {
                "name": "Maize",
                "scientific_name": "Zea mays",
                "category": "Grains",
                "growth_period": "90-120 days",
                "water_requirement": "Medium",
                "soil_ph_range": "5.5-7.5",
                "temperature_range": "18-32°C",
                "description": "Staple food crop in Tanzania",
                "created_at": datetime.utcnow(),
                "updated_at": datetime.utcnow()
            },
            {
                "name": "Beans",
                "scientific_name": "Phaseolus vulgaris",
                "category": "Legumes",
                "growth_period": "60-90 days",
                "water_requirement": "Medium",
                "soil_ph_range": "6.0-7.5",
                "temperature_range": "20-30°C",
                "description": "Important protein source",
                "created_at": datetime.utcnow(),
                "updated_at": datetime.utcnow()
            }
        ]
        
        db.crops_data.insert_many(sample_crops_data)
        print(f"✅ Created {len(sample_crops_data)} sample crops data entries")
        
        # Add sample resources
        sample_resources = [
            {
                "title": "Farming Best Practices",
                "type": "tutorial",
                "description": "Guide to modern farming techniques",
                "url": "https://example.com/farming-guide",
                "created_at": datetime.utcnow()
            },
            {
                "title": "Market Analysis Report",
                "type": "report",
                "description": "Monthly market trends analysis",
                "url": "https://example.com/market-report",
                "created_at": datetime.utcnow()
            }
        ]
        
        db.resources.insert_many(sample_resources)
        print(f"✅ Created {len(sample_resources)} sample resources")
        
        print("\n✅ Database setup completed successfully!")
        print(f"📊 Created {len(collections)} EXACT collections for Flutter app")
        print("🔗 Test user: test@ecofy.com (password: test123)")
        
    except Exception as e:
        print(f"❌ Error setting up database: {e}")
        raise
    finally:
        client.close()

if __name__ == "__main__":
    setup_database()
 