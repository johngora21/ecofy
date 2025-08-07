#!/usr/bin/env python3
"""
Test script for the document monitor
"""

import asyncio
import logging
from app.services.monitor_service import DocumentMonitor
from app.database import get_database

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def test_monitor():
    """Test the document monitor"""
    try:
        logger.info("Testing document monitor...")
        
        # Get database connection
        db = get_database()
        
        # Create monitor
        monitor = DocumentMonitor()
        
        # Load known documents
        monitor.load_known_documents(db)
        logger.info(f"Loaded {len(monitor.known_documents)} known documents")
        
        # Check for new documents
        logger.info("Checking for new documents...")
        new_documents = monitor.check_for_new_documents()
        
        if new_documents:
            logger.info(f"Found {len(new_documents)} new documents:")
            for doc in new_documents:
                logger.info(f"  - {doc['text']} ({doc['date']})")
            
            # Download new documents
            downloaded = monitor.download_new_documents(new_documents, db)
            logger.info(f"Downloaded {downloaded} new documents")
        else:
            logger.info("No new documents found")
        
        # Get monitor status
        total_docs = db.market_prices.count_documents({})
        latest_doc = db.market_prices.find_one(sort=[("scraped_at", -1)])
        
        logger.info(f"Total documents in database: {total_docs}")
        if latest_doc:
            logger.info(f"Latest document: {latest_doc.get('date')} ({latest_doc.get('scraped_at')})")
        
        logger.info("✅ Monitor test completed successfully!")
        
    except Exception as e:
        logger.error(f"❌ Monitor test failed: {e}")
        raise

if __name__ == "__main__":
    asyncio.run(test_monitor())
