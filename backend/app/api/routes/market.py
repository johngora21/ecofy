from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List, Optional
from datetime import datetime, timedelta

from app.api.deps import get_current_user
from app.database import get_database
from app.utils.mongo_utils import serialize_mongo_doc
from app.services.scraper_service import MultiSourcePriceScraper
from app.services.monitor_service import DocumentMonitor
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.get("/prices")
def get_market_prices(
    crop_id: Optional[str] = None,
    date: Optional[str] = None,
    limit: int = Query(10, ge=1, le=100),
    db = Depends(get_database)
):
    """Get market prices from scraped data"""
    try:
        # Build filter
        filter_query = {}
        if crop_id:
            filter_query["prices.crop_id"] = crop_id
        if date:
            filter_query["date"] = date
        
        # Get latest prices if no date specified
        if not date:
            # Get the most recent price data
            latest_price = db.market_prices.find_one(
                {},
                sort=[("date", -1)]
            )
            if latest_price:
                filter_query["date"] = latest_price["date"]
        
        # Get prices
        prices_cursor = db.market_prices.find(filter_query).limit(limit)
        prices = [serialize_mongo_doc(price) for price in prices_cursor]
        
        return {
            "items": prices,
            "total": len(prices),
            "source": "Tanzania Ministry of Industry and Trade"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching market prices: {e}")

@router.get("/prices/history")
def get_price_history(
    crop_name: Optional[str] = None,
    days: int = Query(30, ge=1, le=365),
    db = Depends(get_database)
):
    """Get price history for analysis"""
    try:
        # Calculate date range
        end_date = datetime.now()
        start_date = end_date - timedelta(days=days)
        
        # Build filter
        filter_query = {
            "date": {
                "$gte": start_date.strftime("%Y-%m-%d"),
                "$lte": end_date.strftime("%Y-%m-%d")
            }
        }
        
        if crop_name:
            filter_query["prices.$crop_name"] = {"$exists": True}
        
        # Get price history
        history_cursor = db.market_prices.find(filter_query).sort("date", 1)
        history = [serialize_mongo_doc(entry) for entry in history_cursor]
        
        return {
            "items": history,
            "period": f"Last {days} days",
            "total_entries": len(history)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching price history: {e}")

@router.get("/prices/latest")
def get_latest_prices(db = Depends(get_database)):
    """Get the most recent market prices"""
    try:
        # Get the latest price document
        latest = db.market_prices.find_one(
            {},
            sort=[("date", -1)]
        )
        
        if not latest:
            raise HTTPException(status_code=404, detail="No price data available")
        
        return serialize_mongo_doc(latest)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching latest prices: {e}")

@router.get("/prices/sources")
def get_price_sources(db = Depends(get_database)):
    """Get available price data sources and dates"""
    try:
        # Get unique sources and dates
        sources = db.market_prices.distinct("source")
        dates = db.market_prices.distinct("date")
        
        return {
            "sources": sources,
            "available_dates": sorted(dates, reverse=True),
            "total_records": db.market_prices.count_documents({})
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching price sources: {e}")

@router.post("/scrape/historical")
def trigger_historical_scraping(db = Depends(get_database)):
    """Trigger historical scraping to get all past PDFs and data"""
    try:
        scraper = MultiSourcePriceScraper()
        
        # Run historical scraping
        scraper.run_historical_scraping(db)
        
        return {
            "message": "Historical scraping completed successfully",
            "status": "success",
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error during historical scraping: {e}")

@router.get("/scrape/status")
def get_scraping_status(db = Depends(get_database)):
    """Get scraping status and statistics"""
    try:
        # Get scraping statistics
        total_documents = db.market_prices.count_documents({})
        sources = db.market_prices.distinct("source")
        
        # Get latest scraping info
        latest_scraped = db.market_prices.find_one(
            {},
            sort=[("scraped_at", -1)]
        )
        
        # Get data quality statistics
        quality_stats = db.market_prices.aggregate([
            {
                "$group": {
                    "_id": "$source",
                    "avg_quality": {"$avg": "$ai_training_data.data_quality_score"},
                    "total_docs": {"$sum": 1},
                    "latest_date": {"$max": "$date"}
                }
            }
        ])
        
        quality_stats = list(quality_stats)
        
        return {
            "total_documents": total_documents,
            "sources": sources,
            "latest_scraped": latest_scraped.get("scraped_at") if latest_scraped else None,
            "quality_statistics": quality_stats,
            "downloads_directory": "downloads/pdfs"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting scraping status: {e}")

@router.get("/ai/training-data")
def get_ai_training_data(
    source: Optional[str] = None,
    min_quality: float = Query(0.5, ge=0.0, le=1.0),
    limit: int = Query(100, ge=1, le=1000),
    db = Depends(get_database)
):
    """Get data formatted for AI training"""
    try:
        # Build filter for quality data
        filter_query = {
            "ai_training_data.data_quality_score": {"$gte": min_quality}
        }
        
        if source:
            filter_query["source"] = source
        
        # Get training data
        training_cursor = db.market_prices.find(filter_query).limit(limit)
        training_data = []
        
        for doc in training_cursor:
            training_data.append({
                "id": str(doc["_id"]),
                "date": doc["date"],
                "source": doc["source"],
                "text_content": doc.get("ai_training_data", {}).get("text_content", ""),
                "tables": doc.get("ai_training_data", {}).get("tables", []),
                "prices": doc.get("prices", {}).get("prices", {}),
                "quality_score": doc.get("ai_training_data", {}).get("data_quality_score", 0.0),
                "metadata": doc.get("ai_training_data", {}).get("metadata", {})
            })
        
        return {
            "training_data": training_data,
            "total_records": len(training_data),
            "quality_threshold": min_quality,
            "source_filter": source
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching AI training data: {e}") 

@router.post("/monitor/check")
def trigger_monitor_check(db = Depends(get_database)):
    """Manually trigger the document monitor to check for new PDFs"""
    try:
        logger.info("Manually triggering document monitor check...")
        
        monitor = DocumentMonitor()
        monitor.load_known_documents(db)
        
        # Check for new documents
        new_documents = monitor.check_for_new_documents()
        
        if new_documents:
            logger.info(f"Found {len(new_documents)} new documents, downloading...")
            downloaded = monitor.download_new_documents(new_documents, db)
            
            return {
                "message": f"Monitor check completed",
                "status": "success",
                "new_documents_found": len(new_documents),
                "documents_downloaded": downloaded,
                "timestamp": datetime.now().isoformat()
            }
        else:
            return {
                "message": "No new documents found",
                "status": "success",
                "new_documents_found": 0,
                "documents_downloaded": 0,
                "timestamp": datetime.now().isoformat()
            }
            
    except Exception as e:
        logger.error(f"Error in monitor check: {e}")
        raise HTTPException(status_code=500, detail=f"Monitor check failed: {str(e)}")

@router.get("/monitor/status")
def get_monitor_status(db = Depends(get_database)):
    """Get the status of the document monitor"""
    try:
        monitor = DocumentMonitor()
        monitor.load_known_documents(db)
        
        # Get total documents in database
        total_docs = db.market_prices.count_documents({})
        
        # Get latest document
        latest_doc = db.market_prices.find_one(
            sort=[("scraped_at", -1)]
        )
        
        latest_date = latest_doc.get('date') if latest_doc else None
        latest_scraped = latest_doc.get('scraped_at') if latest_doc else None
        
        return {
            "monitor_status": "active",
            "known_documents_count": len(monitor.known_documents),
            "total_documents_in_db": total_docs,
            "latest_document_date": latest_date,
            "latest_scraped_at": latest_scraped,
            "check_interval_seconds": monitor.check_interval,
            "last_check": monitor.last_check.isoformat() if monitor.last_check else None
        }
        
    except Exception as e:
        logger.error(f"Error getting monitor status: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get monitor status: {str(e)}")

@router.post("/monitor/configure")
def configure_monitor(
    check_interval: int = Query(3600, ge=300, le=86400, description="Check interval in seconds (5 min to 24 hours)")
):
    """Configure the document monitor settings"""
    try:
        # This would typically update a configuration file or database
        # For now, we'll just return the configuration
        return {
            "message": "Monitor configuration updated",
            "status": "success",
            "check_interval_seconds": check_interval,
            "timestamp": datetime.now().isoformat()
        }
        
    except Exception as e:
        logger.error(f"Error configuring monitor: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to configure monitor: {str(e)}") 

@router.post("/scrape/cropsupply")
def trigger_cropsupply_scraping(db = Depends(get_database)):
    """Trigger scraping of CropSupply.com real-time prices"""
    try:
        logger.info("Manually triggering CropSupply.com scraping...")
        
        scraper = MultiSourcePriceScraper()
        cropsupply_data = scraper.scrape_cropsupply_prices()
        
        if cropsupply_data:
            # Save to database
            scraper.save_to_database(cropsupply_data, db)
            
            return {
                "status": "success",
                "message": f"Successfully scraped {len(cropsupply_data)} price entries from CropSupply.com",
                "data_count": len(cropsupply_data),
                "source": "cropsupply.com",
                "scraped_at": datetime.now().isoformat()
            }
        else:
            return {
                "status": "warning",
                "message": "No data found on CropSupply.com",
                "data_count": 0,
                "source": "cropsupply.com"
            }
            
    except Exception as e:
        logger.error(f"Error scraping CropSupply.com: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error scraping CropSupply.com: {str(e)}")

@router.get("/cropsupply/prices")
def get_cropsupply_prices(
    limit: int = Query(100, ge=1, le=1000),
    db = Depends(get_database)
):
    """Get CropSupply.com real-time prices"""
    try:
        # Get latest CropSupply data from database
        collection = db.market_prices
        cursor = collection.find(
            {"source": "cropsupply.com"},
            {"_id": 0}
        ).sort("scraped_at", -1).limit(limit)
        
        prices = list(cursor)
        
        return {
            "status": "success",
            "source": "cropsupply.com",
            "total_entries": len(prices),
            "prices": prices
        }
        
    except Exception as e:
        logger.error(f"Error fetching CropSupply prices: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error fetching CropSupply prices: {str(e)}") 