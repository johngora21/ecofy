#!/usr/bin/env python3
"""
Debug script for CropSupply.com structure
"""

import requests
from bs4 import BeautifulSoup
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def debug_cropsupply_structure():
    """Debug the HTML structure of CropSupply.com"""
    try:
        print("🔍 Debugging CropSupply.com structure...")
        
        session = requests.Session()
        session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        
        response = session.get("https://cropsupply.com/")
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        print(f"✅ Successfully fetched page, status: {response.status_code}")
        
        # Find all tables
        tables = soup.find_all('table')
        print(f"📊 Found {len(tables)} tables on the page")
        
        for table_idx, table in enumerate(tables):
            print(f"\n📋 Table {table_idx + 1}:")
            rows = table.find_all('tr')
            print(f"  Rows: {len(rows)}")
            
            # Show first few rows
            for row_idx, row in enumerate(rows[:5]):
                cells = row.find_all('td')
                print(f"  Row {row_idx + 1}: {len(cells)} cells")
                
                for cell_idx, cell in enumerate(cells):
                    text = cell.get_text(strip=True)
                    if text:
                        print(f"    Cell {cell_idx + 1}: '{text}'")
                    else:
                        # Check for images
                        img = cell.find('img')
                        if img:
                            print(f"    Cell {cell_idx + 1}: [IMAGE] {img.get('src', 'no-src')}")
                        else:
                            print(f"    Cell {cell_idx + 1}: [EMPTY]")
        
        # Look for any divs or other elements that might contain price data
        print("\n🔍 Looking for price-related content...")
        
        # Search for common price indicators
        price_indicators = soup.find_all(text=re.compile(r'\d+\.\d+|\d+'))
        if price_indicators:
            print(f"Found {len(price_indicators)} potential price indicators")
            for i, indicator in enumerate(price_indicators[:10]):
                print(f"  {i+1}. '{indicator.strip()}'")
        
        # Look for crop names
        crop_keywords = ['maize', 'rice', 'beans', 'potatoes', 'tomatoes', 'onions']
        for keyword in crop_keywords:
            elements = soup.find_all(text=re.compile(keyword, re.IGNORECASE))
            if elements:
                print(f"Found '{keyword}' in {len(elements)} places")
        
    except Exception as e:
        print(f"❌ Error debugging CropSupply: {str(e)}")

if __name__ == "__main__":
    import re
    debug_cropsupply_structure()
