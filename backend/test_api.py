#!/usr/bin/env python3
"""
Test script to check the farms API endpoint
"""

import requests
import json

def test_farms_api():
    """Test the farms API endpoint"""
    base_url = "http://localhost:8000/api/v1"
    
    print("🌾 TESTING FARMS API ENDPOINT")
    print("=" * 50)
    
    try:
        # Test the farms endpoint
        response = requests.get(f"{base_url}/farms")
        
        print(f"Status Code: {response.status_code}")
        print(f"Response Headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            farms = response.json()
            print(f"\n✅ Successfully fetched {len(farms)} farms")
            
            print("\n📋 FARMS DATA (JSON format):")
            print(json.dumps(farms, indent=2, default=str))
            
            print(f"\n📊 SUMMARY:")
            print(f"   • Total farms: {len(farms)}")
            
            # Group by location
            locations = {}
            for farm in farms:
                location = farm.get('location', 'Unknown')
                if location not in locations:
                    locations[location] = 0
                locations[location] += 1
            
            print(f"   • Farms by region:")
            for location, count in locations.items():
                print(f"     - {location}: {count} farms")
            
            # Show sample farm structure
            if farms:
                print(f"\n🏡 SAMPLE FARM STRUCTURE:")
                sample_farm = farms[0]
                print(json.dumps(sample_farm, indent=2, default=str))
                
        else:
            print(f"❌ Error: {response.status_code}")
            print(f"Response: {response.text}")
            
    except requests.exceptions.ConnectionError:
        print("❌ Connection Error: Make sure the backend server is running on http://localhost:8000")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    test_farms_api() 
 
"""
Test script to check the farms API endpoint
"""

import requests
import json

def test_farms_api():
    """Test the farms API endpoint"""
    base_url = "http://localhost:8000/api/v1"
    
    print("🌾 TESTING FARMS API ENDPOINT")
    print("=" * 50)
    
    try:
        # Test the farms endpoint
        response = requests.get(f"{base_url}/farms")
        
        print(f"Status Code: {response.status_code}")
        print(f"Response Headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            farms = response.json()
            print(f"\n✅ Successfully fetched {len(farms)} farms")
            
            print("\n📋 FARMS DATA (JSON format):")
            print(json.dumps(farms, indent=2, default=str))
            
            print(f"\n📊 SUMMARY:")
            print(f"   • Total farms: {len(farms)}")
            
            # Group by location
            locations = {}
            for farm in farms:
                location = farm.get('location', 'Unknown')
                if location not in locations:
                    locations[location] = 0
                locations[location] += 1
            
            print(f"   • Farms by region:")
            for location, count in locations.items():
                print(f"     - {location}: {count} farms")
            
            # Show sample farm structure
            if farms:
                print(f"\n🏡 SAMPLE FARM STRUCTURE:")
                sample_farm = farms[0]
                print(json.dumps(sample_farm, indent=2, default=str))
                
        else:
            print(f"❌ Error: {response.status_code}")
            print(f"Response: {response.text}")
            
    except requests.exceptions.ConnectionError:
        print("❌ Connection Error: Make sure the backend server is running on http://localhost:8000")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    test_farms_api() 
 