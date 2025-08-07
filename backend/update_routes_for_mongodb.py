#!/usr/bin/env python3
"""
Update all routes to use MongoDB instead of SQLAlchemy
"""
import os
import re

def update_file(file_path, replacements):
    """Update a file with the given replacements"""
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Apply replacements
        for old, new in replacements:
            content = content.replace(old, new)
        
        with open(file_path, 'w') as f:
            f.write(content)
        
        print(f"✅ Updated {file_path}")
    except Exception as e:
        print(f"❌ Error updating {file_path}: {e}")

def main():
    # Define replacements for each file
    files_to_update = {
        'app/api/routes/users.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('from app.models.user import User', ''),
            ('def get_current_user_info(current_user: User = Depends(get_current_user)):', 'async def get_current_user_info(current_user: dict = Depends(get_current_user)):'),
            ('def update_user(\n    user_in: UserBase,\n    current_user: User = Depends(get_current_user),\n    db: Session = Depends(get_db)\n):', 'async def update_user(\n    user_in: UserBase,\n    current_user: dict = Depends(get_current_user),\n    db = Depends(get_database)\n):'),
            ('def update_language(\n    language_data: dict,\n    current_user: User = Depends(get_current_user),\n    db: Session = Depends(get_db)\n):', 'async def update_language(\n    language_data: dict,\n    current_user: dict = Depends(get_current_user),\n    db = Depends(get_database)\n):'),
            ('    # Update user information\n    current_user.full_name = user_in.full_name\n    current_user.phone_number = user_in.phone_number\n    current_user.location = user_in.location\n    current_user.preferred_language = user_in.preferred_language\n    \n    db.add(current_user)\n    db.commit()\n    db.refresh(current_user)\n    \n    return current_user', '    # Update user information\n    update_data = {\n        "full_name": user_in.full_name,\n        "phone_number": user_in.phone_number,\n        "location": user_in.location,\n        "preferred_language": user_in.preferred_language\n    }\n    \n    await db.users.update_one(\n        {"_id": current_user["_id"]},\n        {"$set": update_data}\n    )\n    \n    # Get updated user\n    updated_user = await db.users.find_one({"_id": current_user["_id"]})\n    return updated_user'),
            ('    current_user.preferred_language = preferred_language\n    db.add(current_user)\n    db.commit()\n    \n    return {\n        "success": True,\n        "preferred_language": preferred_language\n    }', '    await db.users.update_one(\n        {"_id": current_user["_id"]},\n        {"$set": {"preferred_language": preferred_language}}\n    )\n    \n    return {\n        "success": True,\n        "preferred_language": preferred_language\n    }'),
        ],
        'app/api/routes/crops.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_crops(db: Session = Depends(get_db)):', 'async def get_crops(db = Depends(get_database)):'),
            ('    return db.query(Crop).all()', '    crops = await db.crops.find().to_list(length=None)\n    return crops'),
        ],
        'app/api/routes/market.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_market_prices(db: Session = Depends(get_db)):', 'async def get_market_prices(db = Depends(get_database)):'),
            ('    return db.query(MarketPrice).all()', '    prices = await db.market_prices.find().to_list(length=None)\n    return prices'),
        ],
        'app/api/routes/marketplace.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_products(db: Session = Depends(get_db)):', 'async def get_products(db = Depends(get_database)):'),
            ('    return db.query(Product).all()', '    products = await db.products.find().to_list(length=None)\n    return products'),
        ],
        'app/api/routes/orders.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_orders(db: Session = Depends(get_db)):', 'async def get_orders(db = Depends(get_database)):'),
            ('    return db.query(Order).all()', '    orders = await db.orders.find().to_list(length=None)\n    return orders'),
        ],
        'app/api/routes/notifications.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_notifications(db: Session = Depends(get_db)):', 'async def get_notifications(db = Depends(get_database)):'),
            ('    return db.query(Notification).all()', '    notifications = await db.notifications.find().to_list(length=None)\n    return notifications'),
        ],
        'app/api/routes/chat.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_conversations(db: Session = Depends(get_db)):', 'async def get_conversations(db = Depends(get_database)):'),
            ('    return db.query(ChatConversation).all()', '    conversations = await db.chat_conversations.find().to_list(length=None)\n    return conversations'),
        ],
    }
    
    for file_path, replacements in files_to_update.items():
        if os.path.exists(file_path):
            update_file(file_path, replacements)
        else:
            print(f"⚠️  File not found: {file_path}")

if __name__ == "__main__":
    main() 
 
"""
Update all routes to use MongoDB instead of SQLAlchemy
"""
import os
import re

def update_file(file_path, replacements):
    """Update a file with the given replacements"""
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Apply replacements
        for old, new in replacements:
            content = content.replace(old, new)
        
        with open(file_path, 'w') as f:
            f.write(content)
        
        print(f"✅ Updated {file_path}")
    except Exception as e:
        print(f"❌ Error updating {file_path}: {e}")

def main():
    # Define replacements for each file
    files_to_update = {
        'app/api/routes/users.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('from app.models.user import User', ''),
            ('def get_current_user_info(current_user: User = Depends(get_current_user)):', 'async def get_current_user_info(current_user: dict = Depends(get_current_user)):'),
            ('def update_user(\n    user_in: UserBase,\n    current_user: User = Depends(get_current_user),\n    db: Session = Depends(get_db)\n):', 'async def update_user(\n    user_in: UserBase,\n    current_user: dict = Depends(get_current_user),\n    db = Depends(get_database)\n):'),
            ('def update_language(\n    language_data: dict,\n    current_user: User = Depends(get_current_user),\n    db: Session = Depends(get_db)\n):', 'async def update_language(\n    language_data: dict,\n    current_user: dict = Depends(get_current_user),\n    db = Depends(get_database)\n):'),
            ('    # Update user information\n    current_user.full_name = user_in.full_name\n    current_user.phone_number = user_in.phone_number\n    current_user.location = user_in.location\n    current_user.preferred_language = user_in.preferred_language\n    \n    db.add(current_user)\n    db.commit()\n    db.refresh(current_user)\n    \n    return current_user', '    # Update user information\n    update_data = {\n        "full_name": user_in.full_name,\n        "phone_number": user_in.phone_number,\n        "location": user_in.location,\n        "preferred_language": user_in.preferred_language\n    }\n    \n    await db.users.update_one(\n        {"_id": current_user["_id"]},\n        {"$set": update_data}\n    )\n    \n    # Get updated user\n    updated_user = await db.users.find_one({"_id": current_user["_id"]})\n    return updated_user'),
            ('    current_user.preferred_language = preferred_language\n    db.add(current_user)\n    db.commit()\n    \n    return {\n        "success": True,\n        "preferred_language": preferred_language\n    }', '    await db.users.update_one(\n        {"_id": current_user["_id"]},\n        {"$set": {"preferred_language": preferred_language}}\n    )\n    \n    return {\n        "success": True,\n        "preferred_language": preferred_language\n    }'),
        ],
        'app/api/routes/crops.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_crops(db: Session = Depends(get_db)):', 'async def get_crops(db = Depends(get_database)):'),
            ('    return db.query(Crop).all()', '    crops = await db.crops.find().to_list(length=None)\n    return crops'),
        ],
        'app/api/routes/market.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_market_prices(db: Session = Depends(get_db)):', 'async def get_market_prices(db = Depends(get_database)):'),
            ('    return db.query(MarketPrice).all()', '    prices = await db.market_prices.find().to_list(length=None)\n    return prices'),
        ],
        'app/api/routes/marketplace.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_products(db: Session = Depends(get_db)):', 'async def get_products(db = Depends(get_database)):'),
            ('    return db.query(Product).all()', '    products = await db.products.find().to_list(length=None)\n    return products'),
        ],
        'app/api/routes/orders.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_orders(db: Session = Depends(get_db)):', 'async def get_orders(db = Depends(get_database)):'),
            ('    return db.query(Order).all()', '    orders = await db.orders.find().to_list(length=None)\n    return orders'),
        ],
        'app/api/routes/notifications.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_notifications(db: Session = Depends(get_db)):', 'async def get_notifications(db = Depends(get_database)):'),
            ('    return db.query(Notification).all()', '    notifications = await db.notifications.find().to_list(length=None)\n    return notifications'),
        ],
        'app/api/routes/chat.py': [
            ('from sqlalchemy.orm import Session', ''),
            ('from app.database import get_db', 'from app.database import get_database'),
            ('def get_conversations(db: Session = Depends(get_db)):', 'async def get_conversations(db = Depends(get_database)):'),
            ('    return db.query(ChatConversation).all()', '    conversations = await db.chat_conversations.find().to_list(length=None)\n    return conversations'),
        ],
    }
    
    for file_path, replacements in files_to_update.items():
        if os.path.exists(file_path):
            update_file(file_path, replacements)
        else:
            print(f"⚠️  File not found: {file_path}")

if __name__ == "__main__":
    main() 
 