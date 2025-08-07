import requests
import logging
from bs4 import BeautifulSoup
from typing import List, Dict, Any
import re
from datetime import datetime
import json

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CropSupplyScraper:
    """Scraper for CropSupply.com real-time crop prices"""
    
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.base_url = "https://cropsupply.com"
    
    def scrape_crop_prices(self) -> List[Dict[str, Any]]:
        """Scrape real-time crop prices from CropSupply.com"""
        try:
            logger.info("Scraping CropSupply.com for real-time crop prices...")
            
            # Get the main marketplace page
            response = self.session.get(f"{self.base_url}/marketplace")
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            logger.info(f"Successfully fetched CropSupply page, status: {response.status_code}")
            
            # Extract price data from the table
            prices_data = self._extract_price_table(soup)
            
            logger.info(f"Extracted {len(prices_data)} crop price entries from CropSupply.com")
            return prices_data
            
        except Exception as e:
            logger.error(f"Error scraping CropSupply.com: {str(e)}")
            return []
    
    def _extract_price_table(self, soup: BeautifulSoup) -> List[Dict[str, Any]]:
        """Extract price data from the HTML table"""
        prices = []
        
        try:
            # Find the price table - looking for table with crop data
            tables = soup.find_all('table')
            
            for table in tables:
                rows = table.find_all('tr')
                
                for row in rows[1:]:  # Skip header row
                    cells = row.find_all('td')
                    
                    if len(cells) >= 6:  # Ensure we have enough columns
                        try:
                            # Extract data from cells
                            crop_name = cells[1].get_text(strip=True) if len(cells) > 1 else ""
                            quantity = cells[2].get_text(strip=True) if len(cells) > 2 else ""
                            quality = cells[3].get_text(strip=True) if len(cells) > 3 else ""
                            price = cells[4].get_text(strip=True) if len(cells) > 4 else ""
                            region = cells[5].get_text(strip=True) if len(cells) > 5 else ""
                            
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
                                        'data_type': 'real_time_price'
                                    }
                                    prices.append(price_data)
                                    
                        except Exception as e:
                            logger.warning(f"Error parsing row: {str(e)}")
                            continue
            
            logger.info(f"Successfully extracted {len(prices)} price entries")
            return prices
            
        except Exception as e:
            logger.error(f"Error extracting price table: {str(e)}")
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
    
    def get_price_summary(self, prices: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Generate summary statistics for the scraped prices"""
        if not prices:
            return {}
        
        try:
            # Group by crop
            crop_prices = {}
            for price in prices:
                crop = price.get('crop_name', 'Unknown')
                if crop not in crop_prices:
                    crop_prices[crop] = []
                crop_prices[crop].append(price.get('price', 0))
            
            # Calculate statistics
            summary = {
                'total_crops': len(crop_prices),
                'total_entries': len(prices),
                'crops_available': list(crop_prices.keys()),
                'price_range': {
                    'min': min([p.get('price', 0) for p in prices]),
                    'max': max([p.get('price', 0) for p in prices]),
                    'avg': sum([p.get('price', 0) for p in prices]) / len(prices)
                },
                'regions': list(set([p.get('region', '') for p in prices if p.get('region')])),
                'scraped_at': datetime.now().isoformat()
            }
            
            return summary
            
        except Exception as e:
            logger.error(f"Error generating summary: {str(e)}")
            return {}

def test_cropsupply_scraper():
    """Test the CropSupply scraper"""
    try:
        scraper = CropSupplyScraper()
        prices = scraper.scrape_crop_prices()
        
        print(f"✅ Successfully scraped {len(prices)} price entries from CropSupply.com")
        
        if prices:
            summary = scraper.get_price_summary(prices)
            print(f"📊 Summary: {summary['total_crops']} crops, {summary['total_entries']} entries")
            print(f"💰 Price range: {summary['price_range']['min']} - {summary['price_range']['max']} TSh")
            print(f"🌍 Regions: {', '.join(summary['regions'])}")
            
            # Show first few entries
            print("\n📋 Sample entries:")
            for i, price in enumerate(prices[:5]):
                print(f"  {i+1}. {price['crop_name']} - {price['price']} TSh ({price['region']})")
        
        return prices
        
    except Exception as e:
        print(f"❌ Error testing CropSupply scraper: {str(e)}")
        return []

if __name__ == "__main__":
    test_cropsupply_scraper()
