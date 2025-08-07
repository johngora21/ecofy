#!/usr/bin/env python3
"""
Test MongoDB connection directly
"""
import asyncio
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def test_connection():
    """Test MongoDB connection directly"""
    try:
        print("Testing MongoDB connection...")
        print(f"URL: {settings.MONGODB_URL}")
        print(f"Database: {settings.MONGODB_DATABASE}")
        
        # Try different connection options
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # Try to get data
        farms = await db.farms.find({}).to_list(length=None)
        print(f"✅ Found {len(farms)} farms")
        
        users = await db.users.find({}).to_list(length=None)
        print(f"✅ Found {len(users)} users")
        
        if farms:
            print("First farm:")
            print(farms[0])
        
        client.close()
        return True
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == "__main__":
    asyncio.run(test_connection()) 
 
"""
Test MongoDB connection directly
"""
import asyncio
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def test_connection():
    """Test MongoDB connection directly"""
    try:
        print("Testing MongoDB connection...")
        print(f"URL: {settings.MONGODB_URL}")
        print(f"Database: {settings.MONGODB_DATABASE}")
        
        # Try different connection options
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # Try to get data
        farms = await db.farms.find({}).to_list(length=None)
        print(f"✅ Found {len(farms)} farms")
        
        users = await db.users.find({}).to_list(length=None)
        print(f"✅ Found {len(users)} users")
        
        if farms:
            print("First farm:")
            print(farms[0])
        
        client.close()
        return True
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == "__main__":
    asyncio.run(test_connection()) 
 