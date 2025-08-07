#!/usr/bin/env python3
"""
Test different MongoDB connection options
"""
import asyncio
import sys
import os
from motor.motor_asyncio import AsyncIOMotorClient

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

async def test_connection_options():
    """Test different connection string options"""
    
    # Test different connection strings
    connection_strings = [
        # Option 1: Basic connection
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority",
        
        # Option 2: With explicit TLS
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&tls=true",
        
        # Option 3: With TLS and allow invalid certificates
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&tls=true&tlsAllowInvalidCertificates=true",
        
        # Option 4: With app name
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
        
        # Option 5: With direct connection
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&directConnection=false"
    ]
    
    for i, conn_str in enumerate(connection_strings, 1):
        print(f"\n--- Testing Option {i} ---")
        print(f"Connection string: {conn_str}")
        
        try:
            client = AsyncIOMotorClient(conn_str)
            # Test connection
            await client.admin.command('ping')
            print("✅ SUCCESS: Connection established!")
            
            # Test database access
            db = client.ecofy
            collections = await db.list_collection_names()
            print(f"✅ Database accessible. Collections: {collections}")
            
            client.close()
            print("✅ Connection closed successfully")
            return conn_str  # Return the working connection string
            
        except Exception as e:
            print(f"❌ FAILED: {e}")
            if client:
                client.close()
    
    return None

if __name__ == "__main__":
    working_connection = asyncio.run(test_connection_options())
    if working_connection:
        print(f"\n🎉 Working connection string: {working_connection}")
    else:
        print("\n❌ No connection string worked") 
 
"""
Test different MongoDB connection options
"""
import asyncio
import sys
import os
from motor.motor_asyncio import AsyncIOMotorClient

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

async def test_connection_options():
    """Test different connection string options"""
    
    # Test different connection strings
    connection_strings = [
        # Option 1: Basic connection
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority",
        
        # Option 2: With explicit TLS
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&tls=true",
        
        # Option 3: With TLS and allow invalid certificates
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&tls=true&tlsAllowInvalidCertificates=true",
        
        # Option 4: With app name
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
        
        # Option 5: With direct connection
        "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&directConnection=false"
    ]
    
    for i, conn_str in enumerate(connection_strings, 1):
        print(f"\n--- Testing Option {i} ---")
        print(f"Connection string: {conn_str}")
        
        try:
            client = AsyncIOMotorClient(conn_str)
            # Test connection
            await client.admin.command('ping')
            print("✅ SUCCESS: Connection established!")
            
            # Test database access
            db = client.ecofy
            collections = await db.list_collection_names()
            print(f"✅ Database accessible. Collections: {collections}")
            
            client.close()
            print("✅ Connection closed successfully")
            return conn_str  # Return the working connection string
            
        except Exception as e:
            print(f"❌ FAILED: {e}")
            if client:
                client.close()
    
    return None

if __name__ == "__main__":
    working_connection = asyncio.run(test_connection_options())
    if working_connection:
        print(f"\n🎉 Working connection string: {working_connection}")
    else:
        print("\n❌ No connection string worked") 
 