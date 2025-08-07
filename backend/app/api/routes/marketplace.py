from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Optional
from bson import ObjectId
from datetime import datetime

from app.api.deps import get_current_user
from app.database import get_database
from app.utils.mongo_utils import serialize_mongo_doc

router = APIRouter()

@router.get("/products")
async def get_products(
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    category: Optional[str] = None,
    seller_id: Optional[str] = None,
    db = Depends(get_database)
):
    """Get marketplace products with pagination and filtering"""
    try:
        # Build filter
        filter_query = {}
        if category:
            filter_query["category"] = category
        if seller_id:
            filter_query["seller_id"] = ObjectId(seller_id)
        
        # Calculate skip
        skip = (page - 1) * limit
        
        # Get total count
        total = db.products.count_documents(filter_query)
        
        # Get products
        products_cursor = db.products.find(filter_query).skip(skip).limit(limit)
        products = [serialize_mongo_doc(product) for product in products_cursor]
        
        return {
            "items": products,
            "total": total,
            "page": page,
            "limit": limit,
            "pages": (total + limit - 1) // limit
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching products: {e}")

@router.get("/products/{product_id}")
async def get_product(product_id: str, db = Depends(get_database)):
    """Get a specific product by ID"""
    try:
        product = db.products.find_one({"_id": ObjectId(product_id)})
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")
        
        return serialize_mongo_doc(product)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching product: {e}")

@router.get("/orders")
async def get_orders(
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    status: Optional[str] = None,
    user_id: Optional[str] = None,
    db = Depends(get_database)
):
    """Get marketplace orders with pagination and filtering"""
    try:
        # Build filter
        filter_query = {}
        if status:
            filter_query["status"] = status
        if user_id:
            filter_query["user_id"] = ObjectId(user_id)
        
        # Calculate skip
        skip = (page - 1) * limit
        
        # Get total count
        total = db.orders.count_documents(filter_query)
        
        # Get orders
        orders_cursor = db.orders.find(filter_query).skip(skip).limit(limit)
        orders = [serialize_mongo_doc(order) for order in orders_cursor]
        
        return {
            "items": orders,
            "total": total,
            "page": page,
            "limit": limit,
            "pages": (total + limit - 1) // limit
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching orders: {e}")

@router.get("/orders/{order_id}")
async def get_order(order_id: str, db = Depends(get_database)):
    """Get a specific order by ID"""
    try:
        order = db.orders.find_one({"_id": ObjectId(order_id)})
        if not order:
            raise HTTPException(status_code=404, detail="Order not found")
        
        return serialize_mongo_doc(order)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching order: {e}")

@router.get("/sellers")
async def get_sellers(
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    db = Depends(get_database)
):
    """Get marketplace sellers with pagination"""
    try:
        # Calculate skip
        skip = (page - 1) * limit
        
        # Get total count
        total = db.users.count_documents({"role": "supplier"})
        
        # Get sellers (users with supplier role)
        sellers_cursor = db.users.find({"role": "supplier"}).skip(skip).limit(limit)
        sellers = [serialize_mongo_doc(seller) for seller in sellers_cursor]
        
        return {
            "items": sellers,
            "total": total,
            "page": page,
            "limit": limit,
            "pages": (total + limit - 1) // limit
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching sellers: {e}")

@router.get("/statistics")
async def get_marketplace_statistics(db = Depends(get_database)):
    """Get marketplace statistics"""
    try:
        # Get counts
        total_products = db.products.count_documents({})
        total_orders = db.orders.count_documents({})
        total_sellers = db.users.count_documents({"role": "supplier"})
        
        # Get recent orders
        recent_orders = list(db.orders.find().sort("created_at", -1).limit(5))
        recent_orders = [serialize_mongo_doc(order) for order in recent_orders]
        
        # Get top products
        top_products = list(db.products.find().sort("sales_count", -1).limit(5))
        top_products = [serialize_mongo_doc(product) for product in top_products]
        
        return {
            "total_products": total_products,
            "total_orders": total_orders,
            "total_sellers": total_sellers,
            "recent_orders": recent_orders,
            "top_products": top_products
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching statistics: {e}")

@router.put("/orders/{order_id}/status")
async def update_order_status(
    order_id: str,
    status_data: dict,
    db = Depends(get_database)
):
    """Update order status"""
    try:
        new_status = status_data.get("status")
        if not new_status:
            raise HTTPException(status_code=400, detail="Status is required")
        
        result = db.orders.update_one(
            {"_id": ObjectId(order_id)},
            {"$set": {"status": new_status}}
        )
        
        if result.matched_count == 0:
            raise HTTPException(status_code=404, detail="Order not found")
        
        return {"success": True, "message": "Order status updated"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating order status: {e}") 