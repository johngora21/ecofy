import asyncio
import logging
import time
from datetime import datetime, timedelta
from typing import List, Dict, Any, Set
import requests
from bs4 import BeautifulSoup
from app.services.scraper_service import MultiSourcePriceScraper
from app.database import get_database

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DocumentMonitor:
    """Monitor for new documents and automatically download them"""
    
    def __init__(self):
        self.scraper = MultiSourcePriceScraper()
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.known_documents: Set[str] = set()
        self.last_check = None
        self.check_interval = 3600  # Check every hour (3600 seconds)
        
    def load_known_documents(self, db):
        """Load list of already downloaded documents from database"""
        try:
            # Get all documents from database
            documents = db.market_prices.find({}, {"url": 1, "date": 1})
            for doc in documents:
                if 'url' in doc:
                    self.known_documents.add(doc['url'])
                if 'date' in doc:
                    self.known_documents.add(doc['date'])
            
            logger.info(f"Loaded {len(self.known_documents)} known documents from database")
        except Exception as e:
            logger.error(f"Error loading known documents: {e}")
    
    def check_for_new_documents(self) -> List[Dict[str, Any]]:
        """Check for new documents on the Tanzania website"""
        try:
            base_url = "https://www.viwanda.go.tz/documents/product-prices-domestic"
            logger.info(f"Checking for new documents at: {base_url}")
            
            response = self.session.get(base_url, timeout=30)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            all_links = soup.find_all('a', href=True)
            
            new_documents = []
            
            for link in all_links:
                link_text = link.get_text(strip=True)
                link_url = link.get('href')
                
                # Check if it's a price document
                is_price_link = (
                    'Bei ya Mazao' in link_text or 
                    'Bei za Bidhaa' in link_text or
                    'Wholesale price' in link_text or
                    ('.pdf' in link_url and any(keyword in link_text.lower() for keyword in ['bei', 'price', 'mazao', 'bidhaa']))
                )
                
                if is_price_link and link_url:
                    # Make sure it's a full URL
                    if link_url.startswith('/'):
                        link_url = f"https://www.viwanda.go.tz{link_url}"
                    elif not link_url.startswith('http'):
                        link_url = f"https://www.viwanda.go.tz/{link_url}"
                    
                    # Check if this document is new
                    if link_url not in self.known_documents:
                        logger.info(f"Found NEW document: '{link_text}' -> {link_url}")
                        
                        # Extract date
                        date_str = self.scraper._extract_tanzania_date(link_text)
                        
                        if date_str:
                            new_documents.append({
                                'text': link_text,
                                'url': link_url,
                                'date': date_str,
                                'source': 'Tanzania Ministry of Industry and Trade'
                            })
                        else:
                            logger.warning(f"Could not extract date from new document: {link_text}")
            
            logger.info(f"Found {len(new_documents)} new documents")
            return new_documents
            
        except Exception as e:
            logger.error(f"Error checking for new documents: {e}")
            return []
    
    def download_new_documents(self, new_documents: List[Dict[str, Any]], db):
        """Download and process new documents"""
        downloaded_count = 0
        
        for doc in new_documents:
            try:
                logger.info(f"Downloading new document: {doc['text']}")
                
                # Download and process the document
                filename = f"tanzania_{doc['date']}.pdf"
                document_data = self.scraper._download_and_process_document(
                    doc['url'], 
                    filename, 
                    doc['source']
                )
                
                if document_data:
                    # Add metadata
                    document_data.update({
                        'date': doc['date'],
                        'source': doc['source'],
                        'url': doc['url'],
                        'scraped_at': datetime.now().isoformat(),
                        'is_new': True
                    })
                    
                    # Save to database
                    self.scraper.save_to_database([document_data], db)
                    
                    # Add to known documents
                    self.known_documents.add(doc['url'])
                    self.known_documents.add(doc['date'])
                    
                    downloaded_count += 1
                    logger.info(f"Successfully downloaded new document: {doc['date']}")
                    
            except Exception as e:
                logger.error(f"Error downloading new document {doc['text']}: {e}")
        
        logger.info(f"Downloaded {downloaded_count} new documents")
        return downloaded_count
    
    async def run_monitor(self):
        """Run the document monitor continuously"""
        logger.info("Starting document monitor...")
        
        # Get database connection
        db = get_database()
        
        # Load existing documents
        self.load_known_documents(db)
        
        while True:
            try:
                logger.info("Checking for new documents...")
                
                # Check for new documents
                new_documents = self.check_for_new_documents()
                
                if new_documents:
                    logger.info(f"Found {len(new_documents)} new documents, downloading...")
                    downloaded = self.download_new_documents(new_documents, db)
                    
                    if downloaded > 0:
                        logger.info(f"✅ Successfully downloaded {downloaded} new documents!")
                    else:
                        logger.warning("No new documents were downloaded")
                else:
                    logger.info("No new documents found")
                
                # Update last check time
                self.last_check = datetime.now()
                
                # Wait before next check
                logger.info(f"Next check in {self.check_interval} seconds...")
                await asyncio.sleep(self.check_interval)
                
            except Exception as e:
                logger.error(f"Error in monitor loop: {e}")
                await asyncio.sleep(300)  # Wait 5 minutes before retrying

def start_document_monitor():
    """Start the document monitor in a separate thread"""
    import threading
    
    def run_monitor():
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        monitor = DocumentMonitor()
        loop.run_until_complete(monitor.run_monitor())
    
    # Start monitor in background thread
    monitor_thread = threading.Thread(target=run_monitor, daemon=True)
    monitor_thread.start()
    logger.info("Document monitor started in background thread")
    
    return monitor_thread

# For manual testing
if __name__ == "__main__":
    monitor = DocumentMonitor()
    asyncio.run(monitor.run_monitor())
