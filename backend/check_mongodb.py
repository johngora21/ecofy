#!/usr/bin/env python3
"""
Check MongoDB database contents
"""
import asyncio
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def check_mongodb():
    """Check what's in the MongoDB database"""
    try:
        print("Connecting to MongoDB...")
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # List all databases
        databases = await client.list_database_names()
        print(f"All databases: {databases}")
        
        # List collections in our database
        collections = await db.list_collection_names()
        print(f"Database '{settings.MONGODB_DATABASE}' collections: {collections}")
        
        # Check farms collection
        farms_count = await db.farms.count_documents({})
        print(f"Farms count: {farms_count}")
        
        if farms_count > 0:
            farms = await db.farms.find({}).to_list(length=3)
            print("Sample farms:")
            for farm in farms:
                print(f"  - {farm.get('name', 'Unknown')} in {farm.get('location', 'Unknown')}")
        
        # Check users collection
        users_count = await db.users.count_documents({})
        print(f"Users count: {users_count}")
        
        if users_count > 0:
            users = await db.users.find({}).to_list(length=3)
            print("Sample users:")
            for user in users:
                print(f"  - {user.get('full_name', 'Unknown')} ({user.get('email', 'Unknown')})")
        
        # Check other collections
        for collection_name in collections:
            if collection_name not in ['farms', 'users']:
                count = await db[collection_name].count_documents({})
                print(f"{collection_name} count: {count}")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False
    
    finally:
        client.close()
    
    return True

if __name__ == "__main__":
    asyncio.run(check_mongodb()) 
 
"""
Check MongoDB database contents
"""
import asyncio
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def check_mongodb():
    """Check what's in the MongoDB database"""
    try:
        print("Connecting to MongoDB...")
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # List all databases
        databases = await client.list_database_names()
        print(f"All databases: {databases}")
        
        # List collections in our database
        collections = await db.list_collection_names()
        print(f"Database '{settings.MONGODB_DATABASE}' collections: {collections}")
        
        # Check farms collection
        farms_count = await db.farms.count_documents({})
        print(f"Farms count: {farms_count}")
        
        if farms_count > 0:
            farms = await db.farms.find({}).to_list(length=3)
            print("Sample farms:")
            for farm in farms:
                print(f"  - {farm.get('name', 'Unknown')} in {farm.get('location', 'Unknown')}")
        
        # Check users collection
        users_count = await db.users.count_documents({})
        print(f"Users count: {users_count}")
        
        if users_count > 0:
            users = await db.users.find({}).to_list(length=3)
            print("Sample users:")
            for user in users:
                print(f"  - {user.get('full_name', 'Unknown')} ({user.get('email', 'Unknown')})")
        
        # Check other collections
        for collection_name in collections:
            if collection_name not in ['farms', 'users']:
                count = await db[collection_name].count_documents({})
                print(f"{collection_name} count: {count}")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False
    
    finally:
        client.close()
    
    return True

if __name__ == "__main__":
    asyncio.run(check_mongodb()) 
 