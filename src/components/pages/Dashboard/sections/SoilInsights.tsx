import React from 'react';
import { BarChart3, Loader2, AlertCircle } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import type { WeatherData, SoilParameters } from '../../../../services/api';
import { soilData } from '../../../../data/soilData';

interface SoilInsightsProps {
  selectedCrop: string;
  weatherData?: WeatherData;
  soilData?: SoilParameters;
  weatherLoading?: boolean;
  soilLoading?: boolean;
  weatherError?: string | null;
  soilError?: string | null;
}

const SoilInsights: React.FC<SoilInsightsProps> = ({ 
  selectedCrop, 
  weatherData, 
  soilData: apiSoilData,
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
          <BarChart3 className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Soil Insights: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-emerald-600">
            <Loader2 className="w-5 h-5 animate-spin" />
            Loading soil data...
          </div>
        </div>
      </div>
    );
  }

  if (hasError) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <BarChart3 className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Soil Insights: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading soil data
          </div>
        </div>
      </div>
    );
  }

  const chartData = soilData.map(item => ({
    parameter: item.parameter,
    value: item.value,
    optimalRange: item.optimalRange
  }));

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <BarChart3 className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Soil Insights: {selectedCrop}</h4>
      </div>
      
      {/* API Soil Data */}
      {apiSoilData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Real-time Soil Analysis</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Soil Type:</span>
              <p className="text-gray-600">{apiSoilData.soil_type || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">pH Level:</span>
              <p className="text-gray-600">{apiSoilData.ph || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">Organic Matter:</span>
              <p className="text-gray-600">{apiSoilData.organic_matter || 'Not available'}%</p>
            </div>
            <div>
              <span className="font-medium">Water Holding:</span>
              <p className="text-gray-600">{apiSoilData.water_holding_capacity || 'Not available'}</p>
            </div>
          </div>
        </div>
      )}

      {/* Weather Context */}
      {weatherData && (
        <div className="bg-green-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-green-600 mb-2">Weather Context</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Temperature:</span>
              <p className="text-gray-600">{weatherData.current.temp}°C</p>
            </div>
            <div>
              <span className="font-medium">Humidity:</span>
              <p className="text-gray-600">{weatherData.current.humidity}%</p>
            </div>
            <div>
              <span className="font-medium">Conditions:</span>
              <p className="text-gray-600">{weatherData.current.weather[0]?.description}</p>
            </div>
            <div>
              <span className="font-medium">Location:</span>
              <p className="text-gray-600">{weatherData.location.name}</p>
            </div>
          </div>
        </div>
      )}

      {/* Soil Parameters Chart */}
      <div className="bg-white rounded-lg p-4 mb-6">
        <h5 className="font-semibold text-gray-800 mb-4">Soil Parameters Analysis</h5>
        <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="parameter" />
            <YAxis />
              <Tooltip />
            <Bar dataKey="value" fill="#10b981" />
          </BarChart>
        </ResponsiveContainer>
      </div>
      </div>

      {/* Soil Recommendations */}
      <div className="bg-emerald-50 rounded-lg p-4">
        <h5 className="font-semibold text-emerald-600 mb-2">Soil Recommendations for {selectedCrop}</h5>
        <div className="text-sm text-gray-700 space-y-2">
          <p>• Monitor soil pH levels and maintain optimal range for {selectedCrop}</p>
          <p>• Ensure adequate organic matter content for nutrient retention</p>
          <p>• Implement proper irrigation practices based on water holding capacity</p>
          <p>• Regular soil testing recommended for sustainable farming</p>
        </div>
      </div>
    </div>
  );
};

export default SoilInsights;
          <h4 className="font-semibold">Soil Insights: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading soil data
          </div>
        </div>
      </div>
    );
  }

  const chartData = soilData.map(item => ({
    parameter: item.parameter,
    value: item.value,
    optimalRange: item.optimalRange
  }));

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <BarChart3 className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Soil Insights: {selectedCrop}</h4>
      </div>
      
      {/* API Soil Data */}
      {apiSoilData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Real-time Soil Analysis</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Soil Type:</span>
              <p className="text-gray-600">{apiSoilData.soil_type || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">pH Level:</span>
              <p className="text-gray-600">{apiSoilData.ph || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">Organic Matter:</span>
              <p className="text-gray-600">{apiSoilData.organic_matter || 'Not available'}%</p>
            </div>
            <div>
              <span className="font-medium">Water Holding:</span>
              <p className="text-gray-600">{apiSoilData.water_holding_capacity || 'Not available'}</p>
            </div>
          </div>
        </div>
      )}

      {/* Weather Context */}
      {weatherData && (
        <div className="bg-green-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-green-600 mb-2">Weather Context</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Temperature:</span>
              <p className="text-gray-600">{weatherData.current.temp}°C</p>
            </div>
            <div>
              <span className="font-medium">Humidity:</span>
              <p className="text-gray-600">{weatherData.current.humidity}%</p>
            </div>
            <div>
              <span className="font-medium">Conditions:</span>
              <p className="text-gray-600">{weatherData.current.weather[0]?.description}</p>
            </div>
            <div>
              <span className="font-medium">Location:</span>
              <p className="text-gray-600">{weatherData.location.name}</p>
            </div>
          </div>
        </div>
      )}

      {/* Soil Parameters Chart */}
      <div className="bg-white rounded-lg p-4 mb-6">
        <h5 className="font-semibold text-gray-800 mb-4">Soil Parameters Analysis</h5>
        <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="parameter" />
            <YAxis />
              <Tooltip />
            <Bar dataKey="value" fill="#10b981" />
          </BarChart>
        </ResponsiveContainer>
      </div>
      </div>

      {/* Soil Recommendations */}
      <div className="bg-emerald-50 rounded-lg p-4">
        <h5 className="font-semibold text-emerald-600 mb-2">Soil Recommendations for {selectedCrop}</h5>
        <div className="text-sm text-gray-700 space-y-2">
          <p>• Monitor soil pH levels and maintain optimal range for {selectedCrop}</p>
          <p>• Ensure adequate organic matter content for nutrient retention</p>
          <p>• Implement proper irrigation practices based on water holding capacity</p>
          <p>• Regular soil testing recommended for sustainable farming</p>
        </div>
      </div>
    </div>
  );
};

export default SoilInsights;