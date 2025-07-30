export interface FarmData {
  id: number;
  name: string;
  location: string;
  size: string;
  sizeInAcres: number;
  image: string;
  soilMoisture: string;
  organicCarbon: string;
  soilTexture: string;
  soilPH: string;
  ec: string;
  salinity: string;
  waterHoldingCapacity: string;
  organicMatter: string;
  npk: string;
  crops: string[];
  latitude: string;
  longitude: string;
  topography: string;
}

export const initialFarms: FarmData[] = [
  {
    id: 1,
    name: 'Green Valley Farm',
    location: 'Arusha',
    size: '25 acres',
    sizeInAcres: 25,
    image: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&h=200&fit=crop',
    soilMoisture: '60%',
    organicCarbon: '2.5%',
    soilTexture: 'Loamy',
    soilPH: '6.5',
    ec: '0.35 dS/m',
    salinity: 'Low',
    waterHoldingCapacity: 'Medium',
    organicMatter: 'Medium',
    npk: 'N: Medium, P: Low, K: High',
    crops: ['Maize', 'Beans', 'Tomatoes'],
    latitude: '-6.8235',
    longitude: '37.6822',
    topography: 'Flat to gently undulating'
  },
  {
    id: 2,
    name: 'Sunrise Agricultural Estate',
    location: 'Morogoro',
    size: '50 acres',
    sizeInAcres: 50,
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=200&fit=crop',
    soilMoisture: '45%',
    organicCarbon: '1.8%',
    soilTexture: 'Sandy Loam',
    soilPH: '5.8',
    ec: '0.28 dS/m',
    salinity: 'Very Low',
    waterHoldingCapacity: 'Low',
    organicMatter: 'Low',
    npk: 'N: Low, P: Medium, K: Medium',
    crops: ['Rice', 'Cassava', 'Sweet Potatoes'],
    latitude: '-6.8235',
    longitude: '37.6822',
    topography: 'Gently sloping'
  },
  {
    id: 3,
    name: 'Highland Dairy Farm',
    location: 'Kilimanjaro',
    size: '15 acres',
    sizeInAcres: 15,
    image: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=200&fit=crop',
    soilMoisture: '75%',
    organicCarbon: '3.2%',
    soilTexture: 'Clay Loam',
    soilPH: '7.2',
    ec: '0.45 dS/m',
    salinity: 'Medium',
    waterHoldingCapacity: 'High',
    organicMatter: 'High',
    npk: 'N: High, P: Medium, K: Medium',
    crops: ['Alfalfa', 'Corn Silage', 'Pasture Grass'],
    latitude: '-6.8235',
    longitude: '37.6822',
    topography: 'Rolling hills'
  },
  {
    id: 4,
    name: 'Coastal Vegetable Farm',
    location: 'Dar es Salaam',
    size: '8 acres',
    sizeInAcres: 8,
    image: 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=400&h=200&fit=crop',
    soilMoisture: '55%',
    organicCarbon: '2.1%',
    soilTexture: 'Silty Clay',
    soilPH: '6.8',
    ec: '0.38 dS/m',
    salinity: 'Low',
    waterHoldingCapacity: 'Medium',
    organicMatter: 'Medium',
    npk: 'N: Medium, P: High, K: Low',
    crops: ['Lettuce', 'Cabbage', 'Carrots', 'Onions'],
    latitude: '-6.8235',
    longitude: '37.6822',
    topography: 'Flat coastal plain'
  }
];