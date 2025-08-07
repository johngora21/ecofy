#!/usr/bin/env python3
"""
Test script for CropSupply.com scraper
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.services.scraper_service import MultiSourcePriceScraper
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def test_cropsupply_scraper():
    """Test the CropSupply scraper"""
    try:
        print("🌾 Testing CropSupply.com scraper...")
        
        scraper = MultiSourcePriceScraper()
        prices = scraper.scrape_cropsupply_prices()
        
        print(f"✅ Successfully scraped {len(prices)} price entries from CropSupply.com")
        
        if prices:
            print(f"📊 Summary: {len(prices)} real-time price entries")
            
            # Show sample entries
            print("\n📋 Sample entries:")
            for i, price in enumerate(prices[:10]):
                print(f"  {i+1}. {price.get('crop_name', 'Unknown')} - {price.get('price', 0)} TSh ({price.get('region', 'Unknown')})")
            
            # Calculate statistics
            if prices:
                all_prices = [p.get('price', 0) for p in prices if p.get('price')]
                if all_prices:
                    print(f"\n💰 Price Statistics:")
                    print(f"  Min: {min(all_prices)} TSh")
                    print(f"  Max: {max(all_prices)} TSh")
                    print(f"  Avg: {sum(all_prices) / len(all_prices):.2f} TSh")
                
                # Show unique crops
                crops = list(set([p.get('crop_name', '') for p in prices if p.get('crop_name')]))
                print(f"\n🌱 Crops available: {len(crops)}")
                print(f"  {', '.join(crops[:10])}{'...' if len(crops) > 10 else ''}")
                
                # Show regions
                regions = list(set([p.get('region', '') for p in prices if p.get('region')]))
                print(f"\n🌍 Regions: {len(regions)}")
                print(f"  {', '.join(regions[:10])}{'...' if len(regions) > 10 else ''}")
        
        return prices
        
    except Exception as e:
        print(f"❌ Error testing CropSupply scraper: {str(e)}")
        return []

if __name__ == "__main__":
    test_cropsupply_scraper()
