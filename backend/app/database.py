from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from app.core.config import settings

class Database:
    client: MongoClient = None
    database = None

db = Database()

def connect_to_mongo():
    """Create database connection."""
    try:
        # Configure MongoDB client with simpler settings
        db.client = MongoClient(
            settings.MONGODB_URL,
            server_api=ServerApi('1'),
            connectTimeoutMS=30000,
            socketTimeoutMS=30000
        )
        db.database = db.client[settings.MONGODB_DATABASE]
        print("Connected to MongoDB.")
    except Exception as e:
        print(f"Error connecting to MongoDB: {e}")
        # Fallback to a simpler connection
        try:
            db.client = MongoClient(
                settings.MONGODB_URL,
                server_api=ServerApi('1')
            )
            db.database = db.client[settings.MONGODB_DATABASE]
            print("Connected to MongoDB with fallback settings.")
        except Exception as e2:
            print(f"Fallback connection also failed: {e2}")
            raise

def close_mongo_connection():
    """Close database connection."""
    if db.client:
        db.client.close()
        print("Disconnected from MongoDB.")

def get_database():
    """Get database instance."""
    return db.database