#!/usr/bin/env python3
"""
Setup script for all mobile app collections
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

def setup_mobile_collections():
    """Set up all collections needed for the mobile app"""
    print("Setting up all mobile app collections...")
    
    # Connect to MongoDB
    client = MongoClient(settings.MONGODB_URL, server_api=ServerApi('1'))
    db = client[settings.MONGODB_DATABASE]
    
    try:
        # All collections needed for the mobile app
        mobile_collections = [
            # Core collections (already exist)
            'users', 'farms', 'crops',
            
            # Marketplace & Commerce
            'products', 'orders', 'marketplace',
            
            # AI & Communication
            'chat_sessions', 'chat_messages', 'notifications',
            
            # Agricultural Data
            'soil_data', 'weather_data', 'crop_conditions',
            
            # IoT & Monitoring
            'iot_devices', 'sensor_data',
            
            # Field Operations
            'field_teams', 'training_programs', 'regional_agents',
            
            # Market Intelligence
            'market_prices', 'market_intelligence',
            
            # Resources & Education
            'resources', 'tutorials', 'events',
            
            # Analytics & Reports
            'analytics', 'reports'
        ]
        
        # Create collections if they don't exist
        existing_collections = db.list_collection_names()
        for collection_name in mobile_collections:
            if collection_name not in existing_collections:
                db.create_collection(collection_name)
                print(f"✅ Created collection: {collection_name}")
            else:
                print(f"ℹ️  Collection already exists: {collection_name}")
        
        # Get existing user for sample data
        existing_user = db.users.find_one({"email": "test@ecofy.com"})
        if existing_user:
            user_id = existing_user["_id"]
            print(f"✅ Using existing user: {existing_user['full_name']}")
        else:
            print("❌ No test user found")
            return
        
        # Add sample products
        existing_products = db.products.count_documents({})
        if existing_products == 0:
            sample_products = [
                {
                    "name": "Organic Maize Seeds",
                    "category": "Seeds",
                    "price": 2500,
                    "currency": "TZS",
                    "description": "High-yield organic maize seeds",
                    "seller_id": user_id,
                    "stock": 100,
                    "unit": "kg",
                    "location": "Arusha",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "NPK Fertilizer",
                    "category": "Fertilizers",
                    "price": 45000,
                    "currency": "TZS",
                    "description": "Balanced NPK fertilizer for all crops",
                    "seller_id": user_id,
                    "stock": 50,
                    "unit": "bags",
                    "location": "Kilimanjaro",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Tomato Seeds",
                    "category": "Seeds",
                    "price": 1500,
                    "currency": "TZS",
                    "description": "Disease-resistant tomato seeds",
                    "seller_id": user_id,
                    "stock": 200,
                    "unit": "packets",
                    "location": "Morogoro",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            db.products.insert_many(sample_products)
            print(f"✅ Created {len(sample_products)} sample products")
        
        # Add sample orders
        existing_orders = db.orders.count_documents({})
        if existing_orders == 0:
            sample_orders = [
                {
                    "user_id": user_id,
                    "product_id": "1",
                    "quantity": 5,
                    "total_amount": 12500,
                    "currency": "TZS",
                    "status": "completed",
                    "order_date": datetime.utcnow(),
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            db.orders.insert_many(sample_orders)
            print(f"✅ Created {len(sample_orders)} sample orders")
        
        # Add sample marketplace data
        existing_marketplace = db.marketplace.count_documents({})
        if existing_marketplace == 0:
            sample_marketplace = [
                {
                    "product_name": "Maize",
                    "current_price": 1200,
                    "currency": "TZS",
                    "unit": "kg",
                    "location": "Arusha",
                    "market_date": datetime.utcnow(),
                    "trend": "stable",
                    "created_at": datetime.utcnow()
                }
            ]
            db.marketplace.insert_many(sample_marketplace)
            print(f"✅ Created {len(sample_marketplace)} sample marketplace entries")
        
        # Add sample notifications
        existing_notifications = db.notifications.count_documents({})
        if existing_notifications == 0:
            sample_notifications = [
                {
                    "user_id": user_id,
                    "title": "Weather Alert",
                    "message": "Heavy rain expected in Arusha tomorrow",
                    "type": "weather",
                    "is_read": False,
                    "created_at": datetime.utcnow()
                },
                {
                    "user_id": user_id,
                    "title": "Market Update",
                    "message": "Maize prices have increased by 10%",
                    "type": "market",
                    "is_read": False,
                    "created_at": datetime.utcnow()
                }
            ]
            db.notifications.insert_many(sample_notifications)
            print(f"✅ Created {len(sample_notifications)} sample notifications")
        
        # Add sample chat sessions
        existing_chat_sessions = db.chat_sessions.count_documents({})
        if existing_chat_sessions == 0:
            sample_chat_sessions = [
                {
                    "user_id": user_id,
                    "session_id": str(uuid.uuid4()),
                    "topic": "Crop Disease",
                    "status": "active",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            db.chat_sessions.insert_many(sample_chat_sessions)
            print(f"✅ Created {len(sample_chat_sessions)} sample chat sessions")
        
        # Add sample resources
        existing_resources = db.resources.count_documents({})
        if existing_resources == 0:
            sample_resources = [
                {
                    "title": "Maize Farming Guide",
                    "category": "Farming Guide",
                    "description": "Complete guide to maize farming in Tanzania",
                    "file_url": "https://example.com/maize-guide.pdf",
                    "created_at": datetime.utcnow()
                },
                {
                    "title": "Soil Testing Methods",
                    "category": "Technical",
                    "description": "How to test soil quality and pH levels",
                    "file_url": "https://example.com/soil-testing.pdf",
                    "created_at": datetime.utcnow()
                }
            ]
            db.resources.insert_many(sample_resources)
            print(f"✅ Created {len(sample_resources)} sample resources")
        
        print("\n🎉 All mobile app collections setup completed successfully!")
        print(f"📊 Total collections: {len(db.list_collection_names())}")
        
    except Exception as e:
        print(f"❌ Error setting up collections: {e}")
        raise
    finally:
        client.close()

if __name__ == "__main__":
    setup_mobile_collections() 
 
"""
Setup script for all mobile app collections
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

def setup_mobile_collections():
    """Set up all collections needed for the mobile app"""
    print("Setting up all mobile app collections...")
    
    # Connect to MongoDB
    client = MongoClient(settings.MONGODB_URL, server_api=ServerApi('1'))
    db = client[settings.MONGODB_DATABASE]
    
    try:
        # All collections needed for the mobile app
        mobile_collections = [
            # Core collections (already exist)
            'users', 'farms', 'crops',
            
            # Marketplace & Commerce
            'products', 'orders', 'marketplace',
            
            # AI & Communication
            'chat_sessions', 'chat_messages', 'notifications',
            
            # Agricultural Data
            'soil_data', 'weather_data', 'crop_conditions',
            
            # IoT & Monitoring
            'iot_devices', 'sensor_data',
            
            # Field Operations
            'field_teams', 'training_programs', 'regional_agents',
            
            # Market Intelligence
            'market_prices', 'market_intelligence',
            
            # Resources & Education
            'resources', 'tutorials', 'events',
            
            # Analytics & Reports
            'analytics', 'reports'
        ]
        
        # Create collections if they don't exist
        existing_collections = db.list_collection_names()
        for collection_name in mobile_collections:
            if collection_name not in existing_collections:
                db.create_collection(collection_name)
                print(f"✅ Created collection: {collection_name}")
            else:
                print(f"ℹ️  Collection already exists: {collection_name}")
        
        # Get existing user for sample data
        existing_user = db.users.find_one({"email": "test@ecofy.com"})
        if existing_user:
            user_id = existing_user["_id"]
            print(f"✅ Using existing user: {existing_user['full_name']}")
        else:
            print("❌ No test user found")
            return
        
        # Add sample products
        existing_products = db.products.count_documents({})
        if existing_products == 0:
            sample_products = [
                {
                    "name": "Organic Maize Seeds",
                    "category": "Seeds",
                    "price": 2500,
                    "currency": "TZS",
                    "description": "High-yield organic maize seeds",
                    "seller_id": user_id,
                    "stock": 100,
                    "unit": "kg",
                    "location": "Arusha",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "NPK Fertilizer",
                    "category": "Fertilizers",
                    "price": 45000,
                    "currency": "TZS",
                    "description": "Balanced NPK fertilizer for all crops",
                    "seller_id": user_id,
                    "stock": 50,
                    "unit": "bags",
                    "location": "Kilimanjaro",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                },
                {
                    "name": "Tomato Seeds",
                    "category": "Seeds",
                    "price": 1500,
                    "currency": "TZS",
                    "description": "Disease-resistant tomato seeds",
                    "seller_id": user_id,
                    "stock": 200,
                    "unit": "packets",
                    "location": "Morogoro",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            db.products.insert_many(sample_products)
            print(f"✅ Created {len(sample_products)} sample products")
        
        # Add sample orders
        existing_orders = db.orders.count_documents({})
        if existing_orders == 0:
            sample_orders = [
                {
                    "user_id": user_id,
                    "product_id": "1",
                    "quantity": 5,
                    "total_amount": 12500,
                    "currency": "TZS",
                    "status": "completed",
                    "order_date": datetime.utcnow(),
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            db.orders.insert_many(sample_orders)
            print(f"✅ Created {len(sample_orders)} sample orders")
        
        # Add sample marketplace data
        existing_marketplace = db.marketplace.count_documents({})
        if existing_marketplace == 0:
            sample_marketplace = [
                {
                    "product_name": "Maize",
                    "current_price": 1200,
                    "currency": "TZS",
                    "unit": "kg",
                    "location": "Arusha",
                    "market_date": datetime.utcnow(),
                    "trend": "stable",
                    "created_at": datetime.utcnow()
                }
            ]
            db.marketplace.insert_many(sample_marketplace)
            print(f"✅ Created {len(sample_marketplace)} sample marketplace entries")
        
        # Add sample notifications
        existing_notifications = db.notifications.count_documents({})
        if existing_notifications == 0:
            sample_notifications = [
                {
                    "user_id": user_id,
                    "title": "Weather Alert",
                    "message": "Heavy rain expected in Arusha tomorrow",
                    "type": "weather",
                    "is_read": False,
                    "created_at": datetime.utcnow()
                },
                {
                    "user_id": user_id,
                    "title": "Market Update",
                    "message": "Maize prices have increased by 10%",
                    "type": "market",
                    "is_read": False,
                    "created_at": datetime.utcnow()
                }
            ]
            db.notifications.insert_many(sample_notifications)
            print(f"✅ Created {len(sample_notifications)} sample notifications")
        
        # Add sample chat sessions
        existing_chat_sessions = db.chat_sessions.count_documents({})
        if existing_chat_sessions == 0:
            sample_chat_sessions = [
                {
                    "user_id": user_id,
                    "session_id": str(uuid.uuid4()),
                    "topic": "Crop Disease",
                    "status": "active",
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
            ]
            db.chat_sessions.insert_many(sample_chat_sessions)
            print(f"✅ Created {len(sample_chat_sessions)} sample chat sessions")
        
        # Add sample resources
        existing_resources = db.resources.count_documents({})
        if existing_resources == 0:
            sample_resources = [
                {
                    "title": "Maize Farming Guide",
                    "category": "Farming Guide",
                    "description": "Complete guide to maize farming in Tanzania",
                    "file_url": "https://example.com/maize-guide.pdf",
                    "created_at": datetime.utcnow()
                },
                {
                    "title": "Soil Testing Methods",
                    "category": "Technical",
                    "description": "How to test soil quality and pH levels",
                    "file_url": "https://example.com/soil-testing.pdf",
                    "created_at": datetime.utcnow()
                }
            ]
            db.resources.insert_many(sample_resources)
            print(f"✅ Created {len(sample_resources)} sample resources")
        
        print("\n🎉 All mobile app collections setup completed successfully!")
        print(f"📊 Total collections: {len(db.list_collection_names())}")
        
    except Exception as e:
        print(f"❌ Error setting up collections: {e}")
        raise
    finally:
        client.close()

if __name__ == "__main__":
    setup_mobile_collections() 
 