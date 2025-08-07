#!/usr/bin/env python3
"""
Test MongoDB connection using official MongoDB driver
"""
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# Your MongoDB Atlas connection string
uri = "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("✅ Pinged your deployment. You successfully connected to MongoDB!")
    
    # Test database access
    db = client['ecofy']
    print(f"✅ Successfully accessed database: {db.name}")
    
    # List collections
    collections = db.list_collection_names()
    print(f"✅ Collections in database: {collections}")
    
    # Test reading from farms collection
    farms_count = db.farms.count_documents({})
    print(f"✅ Farms count: {farms_count}")
    
    # Test reading from users collection
    users_count = db.users.count_documents({})
    print(f"✅ Users count: {users_count}")
    
    # Get a sample farm
    sample_farm = db.farms.find_one()
    if sample_farm:
        print("✅ Sample farm data:")
        print(f"   Name: {sample_farm.get('name', 'N/A')}")
        print(f"   Location: {sample_farm.get('location', 'N/A')}")
        print(f"   Size: {sample_farm.get('size', 'N/A')}")
    
except Exception as e:
    print(f"❌ Error: {e}")
finally:
    client.close() 
 
"""
Test MongoDB connection using official MongoDB driver
"""
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# Your MongoDB Atlas connection string
uri = "mongodb+srv://hollohuh:YqAQBikMT3be2Ggk@cluster0.bgs2zbf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("✅ Pinged your deployment. You successfully connected to MongoDB!")
    
    # Test database access
    db = client['ecofy']
    print(f"✅ Successfully accessed database: {db.name}")
    
    # List collections
    collections = db.list_collection_names()
    print(f"✅ Collections in database: {collections}")
    
    # Test reading from farms collection
    farms_count = db.farms.count_documents({})
    print(f"✅ Farms count: {farms_count}")
    
    # Test reading from users collection
    users_count = db.users.count_documents({})
    print(f"✅ Users count: {users_count}")
    
    # Get a sample farm
    sample_farm = db.farms.find_one()
    if sample_farm:
        print("✅ Sample farm data:")
        print(f"   Name: {sample_farm.get('name', 'N/A')}")
        print(f"   Location: {sample_farm.get('location', 'N/A')}")
        print(f"   Size: {sample_farm.get('size', 'N/A')}")
    
except Exception as e:
    print(f"❌ Error: {e}")
finally:
    client.close() 
 