#!/usr/bin/env python3
"""
Simple script to create a test user
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
from datetime import datetime
import uuid
import hashlib

# Database connection
DATABASE_URL = "sqlite:///./ecofy.db"
engine = create_engine(DATABASE_URL)

def create_test_user():
    """Create a test user in the database"""
    print("Creating test user...")
    
    # Create users table if it doesn't exist
    with engine.connect() as conn:
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS users (
                id TEXT PRIMARY KEY,
                email TEXT UNIQUE NOT NULL,
                full_name TEXT NOT NULL,
                phone_number TEXT NOT NULL,
                location TEXT NOT NULL,
                hashed_password TEXT NOT NULL,
                role TEXT NOT NULL DEFAULT 'farmer',
                preferred_language TEXT NOT NULL DEFAULT 'en',
                profile_image TEXT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                is_active BOOLEAN DEFAULT 1
            )
        """))
        
        # Create test user
        user_id = str(uuid.uuid4())
        hashed_password = hashlib.sha256("testpassword123".encode()).hexdigest()
        
        try:
            conn.execute(
                text("""
                    INSERT INTO users (id, email, full_name, phone_number, location, 
                                     hashed_password, role, preferred_language, created_at, updated_at)
                    VALUES (:id, :email, :full_name, :phone_number, :location,
                           :hashed_password, :role, :preferred_language, :created_at, :updated_at)
                """),
                {
                    "id": user_id,
                    "email": "test@ecofy.com",
                    "full_name": "Test Farmer",
                    "phone_number": "+255123456789",
                    "location": "Arusha, Tanzania",
                    "hashed_password": hashed_password,
                    "role": "farmer",
                    "preferred_language": "en",
                    "created_at": datetime.now(),
                    "updated_at": datetime.now()
                }
            )
            conn.commit()
            print(f"Test user created with ID: {user_id}")
            return user_id
        except Exception as e:
            print(f"User might already exist: {e}")
            # Get existing user
            result = conn.execute(text("SELECT id FROM users LIMIT 1"))
            user = result.fetchone()
            if user:
                print(f"Using existing user with ID: {user[0]}")
                return user[0]
            return None

if __name__ == "__main__":
    create_test_user() 
 
"""
Simple script to create a test user
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
from datetime import datetime
import uuid
import hashlib

# Database connection
DATABASE_URL = "sqlite:///./ecofy.db"
engine = create_engine(DATABASE_URL)

def create_test_user():
    """Create a test user in the database"""
    print("Creating test user...")
    
    # Create users table if it doesn't exist
    with engine.connect() as conn:
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS users (
                id TEXT PRIMARY KEY,
                email TEXT UNIQUE NOT NULL,
                full_name TEXT NOT NULL,
                phone_number TEXT NOT NULL,
                location TEXT NOT NULL,
                hashed_password TEXT NOT NULL,
                role TEXT NOT NULL DEFAULT 'farmer',
                preferred_language TEXT NOT NULL DEFAULT 'en',
                profile_image TEXT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                is_active BOOLEAN DEFAULT 1
            )
        """))
        
        # Create test user
        user_id = str(uuid.uuid4())
        hashed_password = hashlib.sha256("testpassword123".encode()).hexdigest()
        
        try:
            conn.execute(
                text("""
                    INSERT INTO users (id, email, full_name, phone_number, location, 
                                     hashed_password, role, preferred_language, created_at, updated_at)
                    VALUES (:id, :email, :full_name, :phone_number, :location,
                           :hashed_password, :role, :preferred_language, :created_at, :updated_at)
                """),
                {
                    "id": user_id,
                    "email": "test@ecofy.com",
                    "full_name": "Test Farmer",
                    "phone_number": "+255123456789",
                    "location": "Arusha, Tanzania",
                    "hashed_password": hashed_password,
                    "role": "farmer",
                    "preferred_language": "en",
                    "created_at": datetime.now(),
                    "updated_at": datetime.now()
                }
            )
            conn.commit()
            print(f"Test user created with ID: {user_id}")
            return user_id
        except Exception as e:
            print(f"User might already exist: {e}")
            # Get existing user
            result = conn.execute(text("SELECT id FROM users LIMIT 1"))
            user = result.fetchone()
            if user:
                print(f"Using existing user with ID: {user[0]}")
                return user[0]
            return None

if __name__ == "__main__":
    create_test_user() 
 