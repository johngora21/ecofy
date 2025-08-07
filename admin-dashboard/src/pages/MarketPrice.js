import React, { useState } from 'react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';
import { TrendingUp, TrendingDown, BarChart3, Lightbulb, LineChart, DollarSign, Activity, MapPin, Calendar, Package } from 'lucide-react';

const MarketPrice = () => {
  const [activeTab, setActiveTab] = useState('crop-prices');
  const [selectedCrop, setSelectedCrop] = useState('Maize');
  const [selectedUnit, setSelectedUnit] = useState('Kilogram (kg)');
  const [selectedLocation, setSelectedLocation] = useState('Arusha');
  const [selectedPeriod, setSelectedPeriod] = useState('3 Months');

  // Full crop list from TanzaniaCrops
  const crops = [
    'Maize', 'Rice', 'Beans', 'Wheat', 'Sorghum', 'Millet', 'Irish Potato', 'Sweet Potato', 
    'Cassava', 'Yam', 'Tomato', 'Onion', 'Carrot', 'Cabbage', 'Lettuce', 'Watermelon', 
    'Pineapple', 'Banana', 'Tea', 'Coffee', 'Cotton', 'Tobacco', 'Vanilla', 'Ginger'
  ];

  const units = [
    'Kilogram (kg)', 'Ton (t)', 'Bag (50kg)', 'Bag (100kg)', 'Piece', 'Liter (L)'
  ];

  const locations = [
    'Arusha', 'Dar es Salaam', 'Dodoma', 'Mbeya', 'Morogoro', 'Mwanza', 
    'Tanga', 'Iringa', 'Tabora', 'Kigoma'
  ];

  const periods = [
    '1 Month', '3 Months', '6 Months', '1 Year', '2 Years', '5 Years'
  ];

  const tabs = [
    { id: 'crop-prices', label: 'Crop Prices' },
    { id: 'comparison', label: 'Comparison' },
    { id: 'news', label: 'News' }
  ];

  // Mock price trend data
  const priceTrendData = {
    'Maize': [
      { month: 'Jan', price: 1200.0, volume: 1500.0 },
      { month: 'Feb', price: 1350.0, volume: 1800.0 },
      { month: 'Mar', price: 1420.0, volume: 2000.0 },
      { month: 'Apr', price: 1380.0, volume: 1900.0 },
      { month: 'May', price: 1550.0, volume: 2200.0 },
      { month: 'Jun', price: 1680.0, volume: 2400.0 },
    ],
    'Rice': [
      { month: 'Jan', price: 2800.0, volume: 800.0 },
      { month: 'Feb', price: 2950.0, volume: 900.0 },
      { month: 'Mar', price: 3100.0, volume: 1000.0 },
      { month: 'Apr', price: 3250.0, volume: 1100.0 },
      { month: 'May', price: 3400.0, volume: 1200.0 },
      { month: 'Jun', price: 3550.0, volume: 1300.0 },
    ],
    'Beans': [
      { month: 'Jan', price: 1800.0, volume: 600.0 },
      { month: 'Feb', price: 1950.0, volume: 700.0 },
      { month: 'Mar', price: 2100.0, volume: 800.0 },
      { month: 'Apr', price: 2250.0, volume: 900.0 },
      { month: 'May', price: 2400.0, volume: 1000.0 },
      { month: 'Jun', price: 2550.0, volume: 1100.0 },
    ],
  };

  // Regional comparison data
  const regionalData = {
    'Maize': {
      'Arusha': 1680, 'Dar es Salaam': 1750, 'Dodoma': 1620, 'Mbeya': 1580,
      'Morogoro': 1650, 'Mwanza': 1700, 'Tanga': 1630, 'Iringa': 1600,
      'Tabora': 1550, 'Kigoma': 1570
    },
    'Rice': {
      'Arusha': 3550, 'Dar es Salaam': 3800, 'Dodoma': 3400, 'Mbeya': 3350,
      'Morogoro': 3500, 'Mwanza': 3650, 'Tanga': 3450, 'Iringa': 3400,
      'Tabora': 3300, 'Kigoma': 3350
    },
    'Beans': {
      'Arusha': 2550, 'Dar es Salaam': 2700, 'Dodoma': 2450, 'Mbeya': 2400,
      'Morogoro': 2500, 'Mwanza': 2600, 'Tanga': 2480, 'Iringa': 2420,
      'Tabora': 2350, 'Kigoma': 2380
    },
  };

  // News data
  const newsData = [
    {
      title: 'Maize Prices Surge 15% in Arusha Region',
      summary: 'Strong demand and limited supply drive prices up in the northern region.',
      date: '2024-06-15',
      category: 'Price Alert',
      impact: 'High',
    },
    {
      title: 'Government Announces New Agricultural Subsidies',
      summary: 'Farmers to receive support for improved seeds and fertilizers.',
      date: '2024-06-14',
      category: 'Policy',
      impact: 'Medium',
    },
    {
      title: 'Rice Production Expected to Increase by 20%',
      summary: 'Favorable weather conditions boost rice cultivation across Tanzania.',
      date: '2024-06-13',
      category: 'Production',
      impact: 'Medium',
    },
    {
      title: 'Export Demand Drives Bean Prices Higher',
      summary: 'International markets show strong interest in Tanzanian beans.',
      date: '2024-06-12',
      category: 'Market Trend',
      impact: 'High',
    },
  ];

  const currentPrice = priceTrendData[selectedCrop]?.[priceTrendData[selectedCrop].length - 1]?.price || 0;
  const previousPrice = priceTrendData[selectedCrop]?.[priceTrendData[selectedCrop].length - 2]?.price || 0;
  const priceChange = currentPrice - previousPrice;
  const priceChangePercent = previousPrice > 0 ? ((priceChange / previousPrice) * 100).toFixed(1) : 0;

  const getImpactColor = (impact) => {
    switch (impact.toLowerCase()) {
      case 'high': return 'bg-red-500';
      case 'medium': return 'bg-yellow-500';
      case 'low': return 'bg-green-500';
      default: return 'bg-gray-500';
    }
  };

  const renderCropPricesTab = () => (
    <div className="space-y-6">
      {/* Price Summary Card */}
      <div className="bg-white rounded-xl shadow-sm p-6">
        <div className="flex items-center mb-4">
          <TrendingUp className="w-6 h-6 text-green-600 mr-3" />
          <h3 className="text-lg font-semibold text-gray-900">Current Price</h3>
        </div>
        <div className="flex items-center mb-2">
          <span className="text-3xl font-bold text-gray-900">{currentPrice.toLocaleString()} TZS</span>
          <div className={`ml-4 px-3 py-1 rounded-full text-sm font-semibold ${
            priceChange >= 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
          }`}>
            {priceChange >= 0 ? '+' : ''}{priceChangePercent}%
          </div>
        </div>
        <p className="text-gray-600">per {selectedUnit} in {selectedLocation}</p>
      </div>

      {/* Price Trend Chart */}
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-3">Price Trend</h3>
        <div className="bg-white rounded-xl shadow-sm p-6">
          <div className="h-64 flex items-center justify-center text-gray-500">
            Price trend chart placeholder for {selectedCrop}
          </div>
        </div>
      </div>

      {/* Volume Chart */}
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-3">Trading Volume</h3>
        <div className="bg-white rounded-xl shadow-sm p-6">
          <div className="h-48 flex items-center justify-center text-gray-500">
            Volume chart placeholder for {selectedCrop}
          </div>
        </div>
      </div>

      {/* Market Statistics */}
      <div className="bg-white rounded-xl shadow-sm p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Market Statistics</h3>
        <div className="grid grid-cols-2 gap-4">
          <div className="bg-green-50 border border-green-200 rounded-lg p-4">
            <div className="flex items-center mb-2">
              <TrendingUp className="w-5 h-5 text-green-600 mr-2" />
              <span className="text-sm text-gray-600">Current Price</span>
            </div>
            <p className="text-lg font-semibold text-gray-900">{currentPrice.toLocaleString()} TZS</p>
          </div>
          <div className={`border rounded-lg p-4 ${
            priceChange >= 0 ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'
          }`}>
            <div className="flex items-center mb-2">
              <TrendingUp className={`w-5 h-5 mr-2 ${priceChange >= 0 ? 'text-green-600' : 'text-red-600'}`} />
              <span className="text-sm text-gray-600">Price Change</span>
            </div>
            <p className={`text-lg font-semibold ${priceChange >= 0 ? 'text-green-600' : 'text-red-600'}`}>
              {priceChange >= 0 ? '+' : ''}{priceChangePercent}%
            </p>
          </div>
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <div className="flex items-center mb-2">
              <Activity className="w-5 h-5 text-blue-600 mr-2" />
              <span className="text-sm text-gray-600">Market Status</span>
            </div>
            <p className="text-lg font-semibold text-gray-900">{priceChange >= 0 ? 'Rising' : 'Falling'}</p>
          </div>
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <div className="flex items-center mb-2">
              <Lightbulb className="w-5 h-5 text-yellow-600 mr-2" />
              <span className="text-sm text-gray-600">Recommendation</span>
            </div>
            <p className="text-lg font-semibold text-gray-900">Monitor closely</p>
          </div>
        </div>
      </div>
    </div>
  );

  const renderComparisonTab = () => (
    <div className="space-y-6">
      {/* Regional Comparison Chart */}
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-3">Regional Price Comparison</h3>
        <div className="bg-white rounded-xl shadow-sm p-6">
          <div className="h-80 flex items-center justify-center text-gray-500">
            Regional comparison chart placeholder for {selectedCrop}
          </div>
        </div>
      </div>

      {/* Regional Price List */}
      <div className="bg-white rounded-xl shadow-sm p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Price by Region</h3>
        <div className="space-y-2">
          {Object.entries(regionalData[selectedCrop] || {}).map(([region, price]) => (
            <div key={region} className={`p-3 rounded-lg border ${
              region === selectedLocation 
                ? 'bg-green-50 border-green-200' 
                : 'bg-gray-50 border-gray-200'
            }`}>
              <div className="flex items-center justify-between">
                <div className="flex items-center">
                  <MapPin className={`w-4 h-4 mr-2 ${
                    region === selectedLocation ? 'text-green-600' : 'text-gray-400'
                  }`} />
                  <span className={`font-medium ${
                    region === selectedLocation ? 'text-green-600' : 'text-gray-900'
                  }`}>{region}</span>
                </div>
                <span className="font-semibold text-gray-900">{price.toLocaleString()} TZS</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  const renderNewsTab = () => (
    <div className="space-y-6">
      <h3 className="text-lg font-semibold text-gray-900">Market News & Updates</h3>
      <div className="space-y-4">
        {newsData.map((news, index) => (
          <div key={index} className="bg-white rounded-xl shadow-sm p-6">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center space-x-2">
                <span className={`px-2 py-1 rounded-full text-xs font-semibold text-white ${getImpactColor(news.impact)}`}>
                  {news.category}
                </span>
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                  news.impact === 'High' ? 'bg-red-100 text-red-800' :
                  news.impact === 'Medium' ? 'bg-yellow-100 text-yellow-800' :
                  'bg-green-100 text-green-800'
                }`}>
                  {news.impact}
                </span>
              </div>
              <span className="text-sm text-gray-500">{news.date}</span>
            </div>
            <h4 className="text-lg font-semibold text-gray-900 mb-2">{news.title}</h4>
            <p className="text-gray-600">{news.summary}</p>
          </div>
        ))}
      </div>
    </div>
  );

  const renderTabContent = () => {
    switch (activeTab) {
      case 'crop-prices':
        return renderCropPricesTab();
      case 'comparison':
        return renderComparisonTab();
      case 'news':
        return renderNewsTab();
      default:
        return renderCropPricesTab();
    }
  };

  return (
    <div className="space-y-6">
      {/* Selection Controls */}
      <div className="bg-white rounded-xl shadow-sm p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          {/* Crop and Unit Selection */}
          <div className="flex space-x-3">
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-2">Crop</label>
              <select
                value={selectedCrop}
                onChange={(e) => setSelectedCrop(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
              >
                {crops.map((crop) => (
                  <option key={crop} value={crop}>{crop}</option>
                ))}
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-2">Unit</label>
              <select
                value={selectedUnit}
                onChange={(e) => setSelectedUnit(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
              >
                {units.map((unit) => (
                  <option key={unit} value={unit}>{unit}</option>
                ))}
              </select>
            </div>
          </div>
          
          {/* Location and Period Selection */}
          <div className="flex space-x-3">
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-2">Location</label>
              <select
                value={selectedLocation}
                onChange={(e) => setSelectedLocation(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
              >
                {locations.map((location) => (
                  <option key={location} value={location}>{location}</option>
                ))}
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-sm font-medium text-gray-700 mb-2">Period</label>
              <select
                value={selectedPeriod}
                onChange={(e) => setSelectedPeriod(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
              >
                {periods.map((period) => (
                  <option key={period} value={period}>{period}</option>
                ))}
              </select>
            </div>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="flex space-x-1">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 py-2 px-4 rounded-lg text-sm font-medium transition-colors ${
                activeTab === tab.id
                  ? 'bg-green-600 text-white'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Content Area */}
      <div className="bg-white rounded-xl shadow-sm p-6">
        {renderTabContent()}
      </div>
    </div>
  );
};

export default MarketPrice; 