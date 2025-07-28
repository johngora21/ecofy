import React from 'react';
import { TrendingUp, Loader2, AlertCircle } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import type { WeatherData, SoilParameters } from '../../../../services/api';
import { marketData } from '../../../../data/marketData';

interface MarketIntelligenceProps {
  selectedCrop: string;
  weatherData?: WeatherData;
  soilData?: SoilParameters;
  weatherLoading?: boolean;
  soilLoading?: boolean;
  weatherError?: string | null;
  soilError?: string | null;
}

const MarketIntelligence: React.FC<MarketIntelligenceProps> = ({ 
  selectedCrop, 
  weatherData, 
  soilData,
  weatherLoading,
  soilLoading,
  weatherError,
  soilError
}) => {
  const isLoading = weatherLoading || soilLoading;
  const hasError = weatherError || soilError;

  if (isLoading) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <TrendingUp className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Market Intelligence: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-emerald-600">
            <Loader2 className="w-5 h-5 animate-spin" />
            Loading market data...
          </div>
        </div>
      </div>
    );
  }

  if (hasError) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <TrendingUp className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Market Intelligence: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading market data
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <TrendingUp className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Market Intelligence: {selectedCrop}</h4>
      </div>
      
      {/* Current Market Context */}
      {weatherData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Current Market Context</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Location:</span>
              <p className="text-gray-600">{weatherData.location.name}</p>
            </div>
            <div>
              <span className="font-medium">Temperature:</span>
              <p className="text-gray-600">{weatherData.current.temp}°C</p>
            </div>
            <div>
              <span className="font-medium">Conditions:</span>
              <p className="text-gray-600">{weatherData.current.weather[0]?.description}</p>
            </div>
            <div>
              <span className="font-medium">Humidity:</span>
              <p className="text-gray-600">{weatherData.current.humidity}%</p>
            </div>
          </div>
        </div>
      )}

      {/* Price Analysis */}
      <div className="bg-white rounded-lg p-4 mb-6">
        <h5 className="font-semibold text-gray-800 mb-4">Price Analysis</h5>
        <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={marketData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="month" />
            <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="price" stroke="#10b981" strokeWidth={2} />
          </LineChart>
        </ResponsiveContainer>
        </div>
      </div>
      
      {/* Market Trends */}
      <div className="bg-green-50 rounded-lg p-4 mb-6">
        <h5 className="font-semibold text-green-600 mb-2">Market Trends</h5>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
          <div className="bg-white p-3 rounded-lg">
            <div className="font-medium text-gray-800">Current Price</div>
            <div className="text-2xl font-bold text-green-600">TZS 1,450</div>
            <div className="text-xs text-gray-500">per kg</div>
          </div>
          <div className="bg-white p-3 rounded-lg">
            <div className="font-medium text-gray-800">Price Change</div>
            <div className="text-2xl font-bold text-blue-600">+8.5%</div>
            <div className="text-xs text-gray-500">vs last month</div>
          </div>
          <div className="bg-white p-3 rounded-lg">
            <div className="font-medium text-gray-800">Market Demand</div>
            <div className="text-2xl font-bold text-orange-600">High</div>
            <div className="text-xs text-gray-500">increasing</div>
          </div>
        </div>
      </div>

      {/* Market Recommendations */}
      <div className="bg-emerald-50 rounded-lg p-4">
        <h5 className="font-semibold text-emerald-600 mb-2">Market Recommendations for {selectedCrop}</h5>
        <div className="text-sm text-gray-700 space-y-2">
          <p>• Current prices are favorable for selling - consider market timing</p>
          <p>• Monitor weather patterns as they affect supply and demand</p>
          <p>• Diversify market channels to reduce dependency</p>
          <p>• Stay informed about government policies and subsidies</p>
          <p>• Consider storage options for price optimization</p>
        </div>
      </div>
    </div>
  );
};

export default MarketIntelligence;
          <TrendingUp className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Market Intelligence: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading market data
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <TrendingUp className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Market Intelligence: {selectedCrop}</h4>
      </div>
      
      {/* Current Market Context */}
      {weatherData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Current Market Context</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Location:</span>
              <p className="text-gray-600">{weatherData.location.name}</p>
            </div>
            <div>
              <span className="font-medium">Temperature:</span>
              <p className="text-gray-600">{weatherData.current.temp}°C</p>
            </div>
            <div>
              <span className="font-medium">Conditions:</span>
              <p className="text-gray-600">{weatherData.current.weather[0]?.description}</p>
            </div>
            <div>
              <span className="font-medium">Humidity:</span>
              <p className="text-gray-600">{weatherData.current.humidity}%</p>
            </div>
          </div>
        </div>
      )}

      {/* Price Analysis */}
      <div className="bg-white rounded-lg p-4 mb-6">
        <h5 className="font-semibold text-gray-800 mb-4">Price Analysis</h5>
        <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={marketData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="month" />
            <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="price" stroke="#10b981" strokeWidth={2} />
          </LineChart>
        </ResponsiveContainer>
        </div>
      </div>
      
      {/* Market Trends */}
      <div className="bg-green-50 rounded-lg p-4 mb-6">
        <h5 className="font-semibold text-green-600 mb-2">Market Trends</h5>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
          <div className="bg-white p-3 rounded-lg">
            <div className="font-medium text-gray-800">Current Price</div>
            <div className="text-2xl font-bold text-green-600">TZS 1,450</div>
            <div className="text-xs text-gray-500">per kg</div>
          </div>
          <div className="bg-white p-3 rounded-lg">
            <div className="font-medium text-gray-800">Price Change</div>
            <div className="text-2xl font-bold text-blue-600">+8.5%</div>
            <div className="text-xs text-gray-500">vs last month</div>
          </div>
          <div className="bg-white p-3 rounded-lg">
            <div className="font-medium text-gray-800">Market Demand</div>
            <div className="text-2xl font-bold text-orange-600">High</div>
            <div className="text-xs text-gray-500">increasing</div>
          </div>
        </div>
      </div>

      {/* Market Recommendations */}
      <div className="bg-emerald-50 rounded-lg p-4">
        <h5 className="font-semibold text-emerald-600 mb-2">Market Recommendations for {selectedCrop}</h5>
        <div className="text-sm text-gray-700 space-y-2">
          <p>• Current prices are favorable for selling - consider market timing</p>
          <p>• Monitor weather patterns as they affect supply and demand</p>
          <p>• Diversify market channels to reduce dependency</p>
          <p>• Stay informed about government policies and subsidies</p>
          <p>• Consider storage options for price optimization</p>
        </div>
      </div>
    </div>
  );
};

export default MarketIntelligence;