#!/usr/bin/env python3
"""
Debug script to test farms endpoint
"""
import asyncio
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def test_farms():
    """Test farms retrieval directly"""
    try:
        print("Connecting to MongoDB...")
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # Get farms
        print("Fetching farms...")
        farms = await db.farms.find().to_list(length=None)
        print(f"✅ Found {len(farms)} farms")
        
        # Print first farm as example
        if farms:
            print("First farm:")
            print(farms[0])
        
        return farms
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return None
    
    finally:
        client.close()

if __name__ == "__main__":
    asyncio.run(test_farms()) 
 
"""
Debug script to test farms endpoint
"""
import asyncio
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from motor.motor_asyncio import AsyncIOMotorClient
from app.core.config import settings

async def test_farms():
    """Test farms retrieval directly"""
    try:
        print("Connecting to MongoDB...")
        client = AsyncIOMotorClient(settings.MONGODB_URL)
        db = client[settings.MONGODB_DATABASE]
        
        # Test connection
        await client.admin.command('ping')
        print("✅ Successfully connected to MongoDB!")
        
        # Get farms
        print("Fetching farms...")
        farms = await db.farms.find().to_list(length=None)
        print(f"✅ Found {len(farms)} farms")
        
        # Print first farm as example
        if farms:
            print("First farm:")
            print(farms[0])
        
        return farms
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return None
    
    finally:
        client.close()

if __name__ == "__main__":
    asyncio.run(test_farms()) 
 