import requests
from bs4 import BeautifulSoup
import schedule
import time
from datetime import datetime, timedelta
from typing import List, Dict, Any
import logging
import os
import fitz  # PyMuPDF for PDF processing
import io
from urllib.parse import urljoin, urlparse
import re
import json

logger = logging.getLogger(__name__)

class MultiSourcePriceScraper:
    """Multi-source price scraper for Tanzania and CropSupply.com"""
    
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        
        # Create downloads directory
        self.downloads_dir = "downloads/pdfs"
        os.makedirs(self.downloads_dir, exist_ok=True)
    
    def scrape_all_sources(self) -> List[Dict[str, Any]]:
        """Scrape from all sources"""
        all_data = []
        
        # Scrape Tanzania Ministry documents
        tanzania_data = self.scrape_tanzania_prices()
        all_data.extend(tanzania_data)
        
        # Scrape CropSupply.com real-time prices
        cropsupply_data = self.scrape_cropsupply_prices()
        all_data.extend(cropsupply_data)
        
        logger.info(f"Total data collected: {len(all_data)} entries")
        return all_data
    
    def scrape_tanzania_prices(self) -> List[Dict[str, Any]]:
        """Scrape price data from Tanzania Ministry of Industry and Trade using pagination"""
        try:
            base_url = "https://www.viwanda.go.tz/documents/product-prices-domestic"
            logger.info(f"Scraping Tanzania prices from: {base_url}")
            
            all_price_documents = []
            page = 1
            max_pages = 50  # Limit to prevent infinite loops
            
            while page <= max_pages:
                try:
                    # Use pagination to get all pages
                    if page == 1:
                        url = base_url
                    else:
                        url = f"{base_url}?page={page}"
                    
                    logger.info(f"Scraping page {page}: {url}")
                    
                    response = self.session.get(url, timeout=30)
                    response.raise_for_status()
                    
                    soup = BeautifulSoup(response.content, 'html.parser')
                    
                    # Find all links that might be price documents
                    all_links = soup.find_all('a', href=True)
                    logger.info(f"Found {len(all_links)} links on page {page}")
                    
                    page_documents = []
                    
                    for link in all_links:
                        link_text = link.get_text(strip=True)
                        link_url = link.get('href')
                        
                        # More comprehensive link matching - look for any price-related content
                        is_price_link = (
                            'Bei ya Mazao' in link_text or 
                            'Bei za Bidhaa' in link_text or
                            'Wholesale price' in link_text or
                            'price' in link_text.lower() or
                            'mazao' in link_text.lower() or
                            'bidhaa' in link_text.lower() or
                            ('.pdf' in link_url and any(keyword in link_text.lower() for keyword in ['bei', 'price', 'mazao', 'bidhaa']))
                        )
                        
                        if is_price_link and link_url:
                            # Make sure it's a full URL
                            if link_url.startswith('/'):
                                link_url = f"https://www.viwanda.go.tz{link_url}"
                            elif not link_url.startswith('http'):
                                link_url = f"https://www.viwanda.go.tz/{link_url}"
                            
                            logger.info(f"Found potential price link on page {page}: '{link_text}' -> {link_url}")
                            
                            # Extract date from link text
                            date_str = self._extract_tanzania_date(link_text)
                            
                            if date_str:
                                # Download and process the document
                                filename = f"tanzania_{date_str}.pdf"
                                document_data = self._download_and_process_document(link_url, filename, "Tanzania Ministry of Industry and Trade")
                                
                                if document_data:
                                    document_data['date'] = date_str
                                    document_data['source'] = "Tanzania Ministry of Industry and Trade"
                                    document_data['url'] = link_url
                                    document_data['page_found'] = page
                                    page_documents.append(document_data)
                                    logger.info(f"Successfully processed document for date: {date_str} from page {page}")
                            else:
                                logger.warning(f"Could not extract date from: {link_text}")
                    
                    # If no documents found on this page, we've reached the end
                    if not page_documents:
                        logger.info(f"No more documents found on page {page}, stopping pagination")
                        break
                    
                    all_price_documents.extend(page_documents)
                    logger.info(f"Found {len(page_documents)} documents on page {page}")
                    
                    page += 1
                    
                    # Add a small delay to be respectful to the server
                    import time
                    time.sleep(1)
                    
                except Exception as e:
                    logger.error(f"Error scraping page {page}: {e}")
                    break
            
            logger.info(f"Total price documents found across all pages: {len(all_price_documents)}")
            return all_price_documents
            
        except Exception as e:
            logger.error(f"Error scraping Tanzania prices: {e}")
            return []
    
    def scrape_cropsupply_prices(self) -> List[Dict[str, Any]]:
        """Scrape real-time crop prices from CropSupply.com"""
        try:
            logger.info("Scraping CropSupply.com for real-time crop prices...")
            
            # Get the main page - the price data is on the homepage
            response = self.session.get("https://cropsupply.com/")
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            logger.info(f"Successfully fetched CropSupply page, status: {response.status_code}")
            
            # Extract price data from the table on the main page
            prices_data = self._extract_cropsupply_price_table(soup)
            
            logger.info(f"Extracted {len(prices_data)} crop price entries from CropSupply.com")
            return prices_data
            
        except Exception as e:
            logger.error(f"Error scraping CropSupply.com: {str(e)}")
            return []
    
    def _extract_cropsupply_price_table(self, soup: BeautifulSoup) -> List[Dict[str, Any]]:
        """Extract price data from CropSupply.com HTML table"""
        prices = []
        
        try:
            # Find the price table - looking for table with crop data
            tables = soup.find_all('table')
            logger.info(f"Found {len(tables)} tables on the page")
            
            for table_idx, table in enumerate(tables):
                rows = table.find_all('tr')
                logger.info(f"Table {table_idx + 1}: Found {len(rows)} rows")
                
                for row_idx, row in enumerate(rows[1:]):  # Skip header row
                    cells = row.find_all('td')
                    
                    if len(cells) >= 7:  # Ensure we have enough columns (7 columns: ID, Image, Crop, Quantity, Quality, Price, Region)
                        try:
                            # Extract data from cells based on the actual structure
                            # Structure: ID | Image | Crop | Quantity | Quality | Price | Region
                            crop_name = cells[2].get_text(strip=True) if len(cells) > 2 else ""
                            quantity = cells[3].get_text(strip=True) if len(cells) > 3 else ""
                            quality = cells[4].get_text(strip=True) if len(cells) > 4 else ""
                            price = cells[5].get_text(strip=True) if len(cells) > 5 else ""
                            region = cells[6].get_text(strip=True) if len(cells) > 6 else ""
                            
                            # Clean and validate data
                            if crop_name and price:
                                # Extract numeric price
                                price_numeric = self._extract_numeric_price(price)
                                
                                if price_numeric:
                                    price_data = {
                                        'source': 'cropsupply.com',
                                        'crop_name': crop_name,
                                        'quantity': quantity,
                                        'quality': quality,
                                        'price': price_numeric,
                                        'currency': 'TSh',
                                        'region': region,
                                        'scraped_at': datetime.now().isoformat(),
                                        'data_type': 'real_time_price',
                                        'document_type': 'marketplace_data'
                                    }
                                    prices.append(price_data)
                                    logger.info(f"Added price: {crop_name} - {price_numeric} TSh ({region})")
                                    
                        except Exception as e:
                            logger.warning(f"Error parsing CropSupply row {row_idx}: {str(e)}")
                            continue
            
            logger.info(f"Successfully extracted {len(prices)} CropSupply price entries")
            return prices
            
        except Exception as e:
            logger.error(f"Error extracting CropSupply price table: {str(e)}")
            return []
    
    def _extract_numeric_price(self, price_text: str) -> float:
        """Extract numeric price from text"""
        try:
            # Remove currency symbols and extract numbers
            price_clean = re.sub(r'[^\d.]', '', price_text)
            if price_clean:
                return float(price_clean)
            return None
        except:
            return None
    
    def _extract_tanzania_date(self, text: str) -> str:
        """Extract date from Tanzania price document text"""
        try:
            # Map Swahili months to numbers
            month_map = {
                'Januari': '01', 'Februari': '02', 'Machi': '03', 'Aprili': '04',
                'Mei': '05', 'Juni': '06', 'Julai': '07', 'Agosti': '08',
                'Septemba': '09', 'Oktoba': '10', 'Novemba': '11', 'Desemba': '12'
            }
            
            # Clean the text - remove extra whitespace and newlines
            text = ' '.join(text.split())
            logger.info(f"Cleaned text: {text}")
            
            # Look for patterns like "th.06 Agosti ,2025" or "th.30 Julai 2025"
            
            # Pattern to match "th.06 Agosti ,2025" or "th.30 Julai 2025"
            date_pattern = r'th\.(\d+)\s+(\w+)\s*,?\s*(\d{4})'
            match = re.search(date_pattern, text)
            
            if match:
                day = match.group(1).zfill(2)
                month_name = match.group(2)
                year = match.group(3)
                
                if month_name in month_map:
                    month = month_map[month_name]
                    date_str = f"{year}-{month}-{day}"
                    logger.info(f"Extracted date using regex: {date_str}")
                    return date_str
            
            # Fallback: try to extract from text parts
            parts = text.split()
            day = None
            month = None
            year = None
            
            for i, part in enumerate(parts):
                # Look for day with "th." prefix
                if part.startswith('th.') and part[3:].isdigit():
                    day = part[3:].zfill(2)
                elif part.isdigit() and len(part) <= 2:
                    day = part.zfill(2)
                elif part.isdigit() and len(part) == 4:
                    year = part
                elif part in month_map:
                    month = month_map[part]
            
            if day and month and year:
                date_str = f"{year}-{month}-{day}"
                logger.info(f"Extracted date from parts: {date_str}")
                return date_str
            
            logger.warning(f"Could not extract date from text: {text}")
            return None
            
        except Exception as e:
            logger.error(f"Error extracting date from '{text}': {e}")
            return None
    
    def _download_and_process_document(self, url: str, filename: str, source: str) -> Dict[str, Any]:
        """Download and process PDF document"""
        try:
            logger.info(f"Attempting to download document from: {url}")
            
            # Download the document
            response = self.session.get(url)
            response.raise_for_status()
            logger.info(f"Successfully downloaded document, size: {len(response.content)} bytes")
            
            # Save PDF to disk
            pdf_path = os.path.join(self.downloads_dir, filename)
            with open(pdf_path, 'wb') as f:
                f.write(response.content)
            logger.info(f"Saved PDF to: {pdf_path}")
            
            # Extract text and data from PDF
            pdf_data = self._extract_pdf_data(response.content, source)
            logger.info(f"Extracted PDF data with {len(pdf_data.get('prices', {}))} prices")
            
            return {
                'prices': pdf_data,
                'pdf_path': pdf_path,
                'file_size': len(response.content),
                'content_type': response.headers.get('content-type', 'application/pdf')
            }
            
        except Exception as e:
            logger.error(f"Error downloading/processing document {url}: {e}")
            return {}
    
    def _extract_pdf_data(self, pdf_content: bytes, source: str) -> Dict[str, Any]:
        """Extract text, tables, and metadata from PDF content"""
        try:
            import fitz  # PyMuPDF
            
            # Open PDF from bytes
            pdf_document = fitz.open(stream=pdf_content, filetype="pdf")
            
            text_content = ""
            tables = []
            metadata = {}
            
            # Extract text and tables from each page
            for page_num in range(len(pdf_document)):
                page = pdf_document[page_num]
                
                # Extract text
                text_content += page.get_text()
                
                # Extract tables using PyMuPDF's table finder
                try:
                    # Use the table finder to extract tables
                    tables_on_page = page.find_tables()
                    for table in tables_on_page:
                        table_data = []
                        for row in table.rows:
                            row_data = [cell.text.strip() for cell in row.cells]
                            table_data.append(row_data)
                        tables.append(table_data)
                except Exception as e:
                    logger.warning(f"Error extracting tables from page {page_num}: {e}")
                    # Fallback: try to extract tabular data from text
                    try:
                        # Look for tabular patterns in text
                        lines = page.get_text().split('\n')
                        table_data = []
                        for line in lines:
                            if '\t' in line or '  ' in line:  # Tab or multiple spaces
                                row_data = [cell.strip() for cell in line.split('\t') if cell.strip()]
                                if row_data:
                                    table_data.append(row_data)
                        if table_data:
                            tables.append(table_data)
                    except Exception as fallback_error:
                        logger.warning(f"Fallback table extraction failed: {fallback_error}")
            
            # Extract metadata
            metadata = pdf_document.metadata
            
            pdf_document.close()
            
            # Extract prices from text content
            prices = self._extract_prices_from_text(text_content, source)
            
            return {
                'text_content': text_content,
                'tables': tables,
                'prices': prices,
                'metadata': metadata,
                'pages': len(pdf_document)
            }
            
        except Exception as e:
            logger.error(f"Error extracting PDF data: {e}")
            return {
                'text_content': "",
                'tables': [],
                'prices': {},
                'metadata': {},
                'pages': 0
            }
    
    def _extract_prices_from_text(self, text: str, source: str) -> Dict[str, str]:
        """Extract crop prices from text content"""
        prices = {}
        
        try:
            # Common crop names in Swahili and English
            crop_keywords = {
                'maize': ['maize', 'mahindi', 'corn'],
                'rice': ['rice', 'mchele', 'mpunga'],
                'wheat': ['wheat', 'ngano'],
                'beans': ['beans', 'maharagwe'],
                'potatoes': ['potatoes', 'viazi'],
                'tomatoes': ['tomatoes', 'nyanya'],
                'onions': ['onions', 'kitunguu'],
                'cassava': ['cassava', 'mihogo'],
                'sweet_potatoes': ['sweet potatoes', 'viazi vitamu'],
                'sorghum': ['sorghum', 'mtama'],
                'millet': ['millet', 'ulezi'],
                'groundnuts': ['groundnuts', 'karanga'],
                'sunflower': ['sunflower', 'alizeti'],
                'cotton': ['cotton', 'pamba']
            }
            
            lines = text.split('\n')
            
            for line in lines:
                line = line.strip()
                if not line:
                    continue
                
                # Look for price patterns
                for crop, keywords in crop_keywords.items():
                    for keyword in keywords:
                        if keyword.lower() in line.lower():
                            # Try to extract price
                            price_match = self._extract_price_from_line(line)
                            if price_match:
                                prices[crop] = price_match
                                break
                    if crop in prices:
                        break
            
            return prices
            
        except Exception as e:
            logger.error(f"Error extracting prices from text: {e}")
            return {}
    
    def _extract_price_from_line(self, line: str) -> str:
        """Extract price from a line of text"""
        try:
            # Look for common price patterns
            
            # Pattern for TSh (Tanzanian Shillings)
            tsh_pattern = r'TSH?\s*([\d,]+(?:\.\d{2})?)'
            tsh_match = re.search(tsh_pattern, line, re.IGNORECASE)
            if tsh_match:
                return f"TSh {tsh_match.group(1)}"
            
            # Pattern for USD
            usd_pattern = r'\$?\s*([\d,]+(?:\.\d{2})?)'
            usd_match = re.search(usd_pattern, line)
            if usd_match:
                return f"${usd_match.group(1)}"
            
            # Pattern for numbers that might be prices
            number_pattern = r'([\d,]+(?:\.\d{2})?)'
            number_match = re.search(number_pattern, line)
            if number_match:
                return number_match.group(1)
            
            return ""
            
        except Exception as e:
            logger.error(f"Error extracting price from line: {e}")
            return ""
    
    def save_to_database(self, prices: List[Dict[str, Any]], db):
        """Save scraped prices to database with enhanced storage"""
        try:
            for price_data in prices:
                # Check if data already exists
                existing = db.market_prices.find_one({
                    'date': price_data['date'],
                    'source': price_data['source']
                })
                
                if not existing:
                    # Add additional metadata for AI training
                    price_data['ai_training_data'] = {
                        'text_content': price_data.get('prices', {}).get('text_content', ''),
                        'tables': price_data.get('prices', {}).get('tables', []),
                        'metadata': price_data.get('prices', {}).get('metadata', {}),
                        'processed_at': datetime.now().isoformat(),
                        'data_quality_score': self._calculate_data_quality(price_data)
                    }
                    
                    # Store in database
                    db.market_prices.insert_one(price_data)
                    logger.info(f"Saved prices for {price_data['date']} from {price_data['source']}")
                else:
                    logger.info(f"Prices for {price_data['date']} from {price_data['source']} already exist")
                    
        except Exception as e:
            logger.error(f"Error saving to database: {e}")
    
    def _calculate_data_quality(self, price_data: Dict[str, Any]) -> float:
        """Calculate data quality score for AI training"""
        score = 0.0
        
        try:
            prices = price_data.get('prices', {})
            
            # Score based on text content length
            text_content = prices.get('text_content', '')
            if len(text_content) > 100:
                score += 0.3
            
            # Score based on number of prices extracted
            extracted_prices = prices.get('prices', {})
            if len(extracted_prices) > 0:
                score += 0.4
            
            # Score based on tables found
            tables = prices.get('tables', [])
            if len(tables) > 0:
                score += 0.2
            
            # Score based on metadata completeness
            metadata = prices.get('metadata', {})
            if metadata.get('title') or metadata.get('author'):
                score += 0.1
            
            return min(score, 1.0)
            
        except Exception as e:
            logger.error(f"Error calculating data quality: {e}")
            return 0.0
    
    def run_daily_scraping(self, db):
        """Run daily scraping task for all sources"""
        logger.info("Starting daily multi-source price scraping...")
        prices = self.scrape_all_sources()
        self.save_to_database(prices, db)
        logger.info(f"Completed scraping {len(prices)} price documents from all sources")
    
    def run_historical_scraping(self, db):
        """Run one-time historical scraping to get all past data"""
        logger.info("Starting historical scraping to get all past price data...")
        
        # For Tanzania site, we need to get all historical documents
        # This might require pagination or different approach
        historical_prices = self.scrape_all_sources()
        
        # Save all historical data
        self.save_to_database(historical_prices, db)
        logger.info(f"Completed historical scraping with {len(historical_prices)} documents")

# Scheduler setup
def setup_scraper_scheduler(db):
    """Setup daily scraping schedule"""
    scraper = MultiSourcePriceScraper()
    
    # Schedule daily scraping at 6 AM
    schedule.every().day.at("06:00").do(scraper.run_daily_scraping, db)
    
    # Run scheduler in background
    def run_scheduler():
        while True:
            schedule.run_pending()
            time.sleep(60)
    
    import threading
    scheduler_thread = threading.Thread(target=run_scheduler, daemon=True)
    scheduler_thread.start()
    
    return scraper
