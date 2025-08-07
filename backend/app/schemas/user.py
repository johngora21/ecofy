from pydantic import BaseModel, EmailStr, Field, validator
from typing import List, Optional, Dict
from datetime import datetime
from enum import Enum
import uuid

class UserRole(str, Enum):
    FARMER = "farmer"
    BUYER = "buyer"
    SUPPLIER = "supplier"
    ADMIN = "admin"

class UserBase(BaseModel):
    email: EmailStr
    full_name: str
    phone_number: str
    location: str
    preferred_language: str = "en"

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    phone_number: Optional[str] = None
    location: Optional[str] = None
    preferred_language: Optional[str] = None

class UserResponse(UserBase):
    id: str
    role: UserRole
    created_at: datetime
    profile_image: Optional[str] = None

    class Config:
        orm_mode = True

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse 
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse 