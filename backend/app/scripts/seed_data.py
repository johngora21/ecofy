#!/usr/bin/env python3
"""
Data seeding script for Ecofy backend
Populates the database with Tanzanian regions, districts, and crops
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.database import get_db, engine, Base
from app.models.crop import Crop
from app.models.market import MarketPrice
from datetime import datetime, timedelta
import uuid
import random

# Tanzanian Regions and Districts data
TANZANIA_REGIONS = {
    "Arusha": ["Arusha City", "Arusha Rural", "Karatu", "Longido", "Meru", "Monduli", "Ngorongoro"],
    "Dar es Salaam": ["Ilala", "Kigamboni", "Kinondoni", "Temeke", "Ubungo"],
    "Dodoma": ["Bahi", "Chamwino", "Chemba", "Dodoma City", "Kondoa Rural", "Kondoa Town", "Kongwa", "Mpwapwa"],
    "Geita": ["Bukombe", "Chato", "Geita Rural", "Geita Town", "Mbogwe", "Nyang'hwale"],
    "Iringa": ["Iringa Municipal", "Iringa Rural", "Kilolo", "Mafinga Town", "Mufindi"],
    "Kagera": ["Biharamulo", "Bukoba Municipal", "Bukoba Rural", "Karagwe", "Kyerwa", "Missenyi", "Muleba", "Ngara"],
    "Katavi": ["Mlele", "Mpanda Municipal", "Mpimbwe", "Nsimbo", "Tanganyika"],
    "Kigoma": ["Buhigwe", "Kakonko", "Kasulu Rural", "Kasulu Town", "Kibondo", "Kigoma Municipal", "Kigoma Rural", "Uvinza"],
    "Kilimanjaro": ["Hai", "Moshi Municipal", "Moshi Rural", "Mwanga", "Rombo", "Same", "Siha"],
    "Lindi": ["Kilwa", "Lindi Municipal", "Liwale", "Mtama", "Nachingwea", "Ruangwa"],
    "Manyara": ["Babati Rural", "Babati Town", "Hanang", "Kiteto", "Mbulu Rural", "Mbulu Town", "Simanjiro"],
    "Mara": ["Bunda Rural", "Bunda Town", "Butiama", "Musoma Municipal", "Musoma Rural", "Rorya", "Serengeti", "Tarime Rural", "Tarime Town"],
    "Mbeya": ["Busekelo", "Chunya", "Kyela", "Mbarali", "Mbeya City", "Mbeya Rural", "Rungwe"],
    "Morogoro": ["Gairo", "Ifakara Town", "Kilosa", "Malinyi", "Mlimba", "Morogoro Municipal", "Morogoro Rural", "Mvomero", "Ulanga"],
    "Mtwara": ["Masasi Rural", "Masasi Town", "Mtwara Municipal", "Mtwara Rural", "Nanyamba Town", "Nanyumbu", "Newala Rural", "Newala Town", "Tandahimba"],
    "Mwanza": ["Buchosa", "Ilemela Municipal", "Kwimba", "Magu", "Misungwi", "Mwanza City", "Sengerema", "Ukerewe"],
    "Njombe": ["Ludewa", "Makambako Town", "Makete", "Njombe Rural", "Njombe Town", "Wanging'ombe"],
    "Pwani": ["Bagamoyo", "Chalinze", "Kibaha", "Kibaha Town", "Kibiti", "Kisarawe", "Mafia", "Mkuranga", "Rufiji"],
    "Rukwa": ["Kalambo", "Nkasi", "Sumbawanga Municipal", "Sumbawanga Rural"],
    "Ruvuma": ["Madaba", "Mbinga Rural", "Mbinga Town", "Namtumbo", "Nyasa", "Songea Municipal", "Songea Rural", "Tunduru"],
    "Shinyanga": ["Kahama Municipality", "Kishapu", "Msalala", "Shinyanga Municipal", "Shinyanga Rural", "Ushetu"],
    "Simiyu": ["Bariadi Rural", "Bariadi Town", "Busega", "Itilima", "Maswa", "Meatu"],
    "Singida": ["Ikungi", "Iramba", "Itigi", "Manyoni", "Mkalama", "Singida Municipal", "Singida Rural"],
    "Songwe": ["Ileje", "Mbozi", "Momba", "Songwe", "Tunduma Town"],
    "Tabora": ["Igunga", "Kaliua", "Nzega Rural", "Nzega Town", "Sikonge", "Tabora Municipal", "Urambo", "Uyui"],
    "Tanga": ["Bumbuli", "Handeni Rural", "Handeni Town", "Kilindi", "Korogwe Rural", "Korogwe Town", "Lushoto", "Mkinga", "Muheza", "Pangani", "Tanga City"],
    "Zanzibar Central/South": ["Kati", "Kusini"],
    "Zanzibar North": ["Kaskazini A", "Kaskazini B"],
    "Zanzibar Urban/West": ["Magharibi A", "Magharibi B", "Mjini"],
}

# Tanzanian Crops data
TANZANIA_CROPS = [
    {
        "name": "Maize",
        "scientific_name": "Zea mays",
        "category": "Cereals",
        "description": "Staple food crop widely grown across Tanzania",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "600-1200mm annually",
            "altitude": "0-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 7.5},
            "texture": "Well-drained loamy soil",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Drought stress during flowering",
            "Fall Armyworm infestation",
            "Maize Lethal Necrosis Disease",
            "Price volatility"
        ]
    },
    {
        "name": "Rice",
        "scientific_name": "Oryza sativa",
        "category": "Cereals",
        "description": "Important food crop, especially in irrigated areas",
        "optimal_planting_time": "November to January",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "1000-2000mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 6.5},
            "texture": "Clay loam with good water retention",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Water scarcity",
            "Rice blast disease",
            "Stem borer infestation",
            "Market price fluctuations"
        ]
    },
    {
        "name": "Beans",
        "scientific_name": "Phaseolus vulgaris",
        "category": "Legumes",
        "description": "Protein-rich legume crop",
        "optimal_planting_time": "March to April, October to November",
        "climate_requirements": {
            "temperature": {"min": 18, "max": 28},
            "rainfall": "400-800mm annually",
            "altitude": "800-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.5},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-3%"
        },
        "risks": [
            "Bean fly damage",
            "Anthracnose disease",
            "Drought stress",
            "Low market prices"
        ]
    },
    {
        "name": "Wheat",
        "scientific_name": "Triticum aestivum",
        "category": "Cereals",
        "description": "Cereal crop grown in cooler highland areas",
        "optimal_planting_time": "May to June",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "400-600mm annually",
            "altitude": "1500-2500m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.5},
            "texture": "Well-drained loamy soil",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Rust diseases",
            "Aphid infestation",
            "Frost damage",
            "Limited market access"
        ]
    },
    {
        "name": "Sorghum",
        "scientific_name": "Sorghum bicolor",
        "category": "Cereals",
        "description": "Drought-tolerant cereal crop",
        "optimal_planting_time": "November to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "400-800mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 8.5},
            "texture": "Well-drained sandy loam",
            "organic_matter": "1-3%"
        },
        "risks": [
            "Bird damage",
            "Striga weed",
            "Drought stress",
            "Low market demand"
        ]
    },
    {
        "name": "Millet",
        "scientific_name": "Pennisetum glaucum",
        "category": "Cereals",
        "description": "Drought-resistant cereal crop",
        "optimal_planting_time": "November to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "300-600mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 8.0},
            "texture": "Well-drained sandy soil",
            "organic_matter": "1-2%"
        },
        "risks": [
            "Bird damage",
            "Drought stress",
            "Low yields",
            "Limited market"
        ]
    },
    {
        "name": "Irish Potato",
        "scientific_name": "Solanum tuberosum",
        "category": "Tubers",
        "description": "Important tuber crop grown in highlands",
        "optimal_planting_time": "October to November, March to April",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "600-1000mm annually",
            "altitude": "1500-2500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 6.5},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Late blight disease",
            "Potato tuber moth",
            "Frost damage",
            "Market price volatility"
        ]
    },
    {
        "name": "Sweet Potato",
        "scientific_name": "Ipomoea batatas",
        "category": "Tubers",
        "description": "Nutritious tuber crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "500-1000mm annually",
            "altitude": "0-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 7.0},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Sweet potato weevil",
            "Viral diseases",
            "Drought stress",
            "Storage losses"
        ]
    },
    {
        "name": "Cassava",
        "scientific_name": "Manihot esculenta",
        "category": "Tubers",
        "description": "Drought-tolerant root crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "500-1500mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.0, "max": 7.0},
            "texture": "Well-drained sandy loam",
            "organic_matter": "1-3%"
        },
        "risks": [
            "Cassava mosaic disease",
            "Cassava brown streak disease",
            "Mealybug infestation",
            "Low market prices"
        ]
    },
    {
        "name": "Yam",
        "scientific_name": "Dioscorea spp.",
        "category": "Tubers",
        "description": "Traditional tuber crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "1000-2000mm annually",
            "altitude": "0-1000m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 7.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Yam mosaic virus",
            "Nematode infestation",
            "Drought stress",
            "Limited market access"
        ]
    },
    {
        "name": "Tomato",
        "scientific_name": "Solanum lycopersicum",
        "category": "Vegetables",
        "description": "Popular vegetable crop",
        "optimal_planting_time": "March to April, September to October",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "600-1000mm annually",
            "altitude": "0-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Early blight disease",
            "Tomato fruit worm",
            "Price volatility",
            "Post-harvest losses"
        ]
    },
    {
        "name": "Onion",
        "scientific_name": "Allium cepa",
        "category": "Vegetables",
        "description": "Important vegetable crop",
        "optimal_planting_time": "March to April, September to October",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "400-800mm annually",
            "altitude": "800-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.5},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Onion thrips",
            "Purple blotch disease",
            "Storage losses",
            "Market price fluctuations"
        ]
    },
    {
        "name": "Carrot",
        "scientific_name": "Daucus carota",
        "category": "Vegetables",
        "description": "Root vegetable crop",
        "optimal_planting_time": "March to April, September to October",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "500-800mm annually",
            "altitude": "800-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Carrot fly",
            "Root rot disease",
            "Forked roots",
            "Market access issues"
        ]
    },
    {
        "name": "Cabbage",
        "scientific_name": "Brassica oleracea",
        "category": "Vegetables",
        "description": "Leafy vegetable crop",
        "optimal_planting_time": "March to April, September to October",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "500-800mm annually",
            "altitude": "800-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.5},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Diamondback moth",
            "Black rot disease",
            "Clubroot disease",
            "Price volatility"
        ]
    },
    {
        "name": "Lettuce",
        "scientific_name": "Lactuca sativa",
        "category": "Vegetables",
        "description": "Leafy salad vegetable",
        "optimal_planting_time": "March to April, September to October",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "400-600mm annually",
            "altitude": "800-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Aphid infestation",
            "Downy mildew",
            "Tip burn",
            "Short shelf life"
        ]
    },
    {
        "name": "Watermelon",
        "scientific_name": "Citrullus lanatus",
        "category": "Fruits",
        "description": "Popular fruit crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "500-800mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Fusarium wilt",
            "Anthracnose disease",
            "Drought stress",
            "Market saturation"
        ]
    },
    {
        "name": "Pineapple",
        "scientific_name": "Ananas comosus",
        "category": "Fruits",
        "description": "Tropical fruit crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "1000-1500mm annually",
            "altitude": "0-1000m"
        },
        "soil_requirements": {
            "ph": {"min": 5.0, "max": 6.5},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Mealybug infestation",
            "Heart rot disease",
            "Drought stress",
            "Export market challenges"
        ]
    },
    {
        "name": "Banana",
        "scientific_name": "Musa spp.",
        "category": "Fruits",
        "description": "Important fruit and food crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "1000-2000mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 7.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Panama disease",
            "Black Sigatoka",
            "Banana weevil",
            "Wind damage"
        ]
    },
    {
        "name": "Tea",
        "scientific_name": "Camellia sinensis",
        "category": "Cash Crops",
        "description": "Important cash crop for export",
        "optimal_planting_time": "March to April, October to November",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "1200-2000mm annually",
            "altitude": "1500-2500m"
        },
        "soil_requirements": {
            "ph": {"min": 5.0, "max": 6.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Tea mosquito bug",
            "Red spider mite",
            "Frost damage",
            "Price volatility"
        ]
    },
    {
        "name": "Coffee",
        "scientific_name": "Coffea arabica",
        "category": "Cash Crops",
        "description": "Major export cash crop",
        "optimal_planting_time": "March to April, October to November",
        "climate_requirements": {
            "temperature": {"min": 15, "max": 25},
            "rainfall": "1000-2000mm annually",
            "altitude": "1200-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 5.5, "max": 6.5},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Coffee berry disease",
            "Coffee leaf rust",
            "Coffee berry borer",
            "Price fluctuations"
        ]
    },
    {
        "name": "Cotton",
        "scientific_name": "Gossypium hirsutum",
        "category": "Cash Crops",
        "description": "Fiber crop for textile industry",
        "optimal_planting_time": "November to December",
        "climate_requirements": {
            "temperature": {"min": 25, "max": 35},
            "rainfall": "600-1200mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.5},
            "texture": "Well-drained loamy soil",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Bollworm infestation",
            "Fusarium wilt",
            "Drought stress",
            "Market price volatility"
        ]
    },
    {
        "name": "Tobacco",
        "scientific_name": "Nicotiana tabacum",
        "category": "Cash Crops",
        "description": "Commercial crop for export",
        "optimal_planting_time": "October to November",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "600-1000mm annually",
            "altitude": "800-2000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained sandy loam",
            "organic_matter": "2-4%"
        },
        "risks": [
            "Tobacco mosaic virus",
            "Aphid infestation",
            "Drought stress",
            "Regulatory restrictions"
        ]
    },
    {
        "name": "Vanilla",
        "scientific_name": "Vanilla planifolia",
        "category": "Cash Crops",
        "description": "High-value spice crop",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "1500-2500mm annually",
            "altitude": "0-1000m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Vanilla thrips",
            "Root rot disease",
            "Labor intensive",
            "Price volatility"
        ]
    },
    {
        "name": "Ginger",
        "scientific_name": "Zingiber officinale",
        "category": "Spices",
        "description": "Spice crop with medicinal properties",
        "optimal_planting_time": "October to December",
        "climate_requirements": {
            "temperature": {"min": 20, "max": 30},
            "rainfall": "1000-2000mm annually",
            "altitude": "0-1500m"
        },
        "soil_requirements": {
            "ph": {"min": 6.0, "max": 7.0},
            "texture": "Well-drained loamy soil",
            "organic_matter": "3-5%"
        },
        "risks": [
            "Rhizome rot",
            "Bacterial wilt",
            "Drought stress",
            "Market access issues"
        ]
    }
]

def generate_mock_price_data(crop_name):
    """Generate realistic mock price data for crops"""
    base_prices = {
        "Maize": 1200,
        "Rice": 2800,
        "Beans": 1800,
        "Wheat": 2200,
        "Sorghum": 1000,
        "Millet": 800,
        "Irish Potato": 1500,
        "Sweet Potato": 800,
        "Cassava": 600,
        "Yam": 1200,
        "Tomato": 2500,
        "Onion": 1800,
        "Carrot": 2000,
        "Cabbage": 1200,
        "Lettuce": 1500,
        "Watermelon": 800,
        "Pineapple": 1500,
        "Banana": 1200,
        "Tea": 5000,
        "Coffee": 8000,
        "Cotton": 3000,
        "Tobacco": 12000,
        "Vanilla": 50000,
        "Ginger": 4000,
    }
    
    base_price = base_prices.get(crop_name, 1500)
    
    # Generate 6 months of price data
    price_trend = []
    current_date = datetime.now() - timedelta(days=180)
    
    for i in range(6):
        # Add some realistic price variation
        variation = random.uniform(-0.2, 0.3)  # -20% to +30%
        price = base_price * (1 + variation)
        
        price_trend.append({
            "date": current_date.strftime("%Y-%m-%d"),
            "price": round(price, 2)
        })
        
        current_date += timedelta(days=30)
    
    # Calculate percent change
    if len(price_trend) >= 2:
        first_price = price_trend[0]["price"]
        last_price = price_trend[-1]["price"]
        percent_change = ((last_price - first_price) / first_price) * 100
    else:
        percent_change = 0
    
    return {
        "current_price": price_trend[-1]["price"] if price_trend else base_price,
        "price_trend": price_trend,
        "percent_change": round(percent_change, 2),
        "recommendation": f"Current market conditions for {crop_name} are {'favorable' if percent_change > 0 else 'challenging'}. Consider {'increasing' if percent_change > 5 else 'maintaining' if percent_change > -5 else 'reducing'} production based on price trends."
    }

def seed_crops(db: Session):
    """Seed crops data"""
    print("Seeding crops...")
    
    for crop_data in TANZANIA_CROPS:
        # Check if crop already exists
        existing_crop = db.query(Crop).filter(Crop.name == crop_data["name"]).first()
        if existing_crop:
            print(f"Crop {crop_data['name']} already exists, skipping...")
            continue
        
        crop = Crop(
            id=str(uuid.uuid4()),
            name=crop_data["name"],
            description=crop_data["description"],
            optimal_planting_time=crop_data["optimal_planting_time"],
            climate_requirements=crop_data["climate_requirements"],
            soil_requirements=crop_data["soil_requirements"],
            risks=crop_data["risks"]
        )
        
        db.add(crop)
        print(f"Added crop: {crop_data['name']}")
    
    db.commit()
    print("Crops seeding completed!")

def seed_market_prices(db: Session):
    """Seed market prices data"""
    print("Seeding market prices...")
    
    crops = db.query(Crop).all()
    
    for crop in crops:
        # Check if market price already exists
        existing_price = db.query(MarketPrice).filter(MarketPrice.crop_id == crop.id).first()
        if existing_price:
            print(f"Market price for {crop.name} already exists, skipping...")
            continue
        
        price_data = generate_mock_price_data(crop.name)
        
        market_price = MarketPrice(
            id=str(uuid.uuid4()),
            crop_id=crop.id,
            current_price=price_data["current_price"],
            price_trend=price_data["price_trend"],
            percent_change=price_data["percent_change"],
            recommendation=price_data["recommendation"]
        )
        
        db.add(market_price)
        print(f"Added market price for: {crop.name}")
    
    db.commit()
    print("Market prices seeding completed!")

def main():
    """Main seeding function"""
    print("Starting Ecofy data seeding...")
    
    # Create tables
    Base.metadata.create_all(bind=engine)
    
    # Get database session
    db = next(get_db())
    
    try:
        # Seed crops
        seed_crops(db)
        
        # Seed market prices
        seed_market_prices(db)
        
        print("Data seeding completed successfully!")
        
    except Exception as e:
        print(f"Error during seeding: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    main() 