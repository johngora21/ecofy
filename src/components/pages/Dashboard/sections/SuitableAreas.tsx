import React from 'react';
import { MapPin, Loader2, AlertCircle } from 'lucide-react';
import type { WeatherData, SoilParameters } from '../../../../services/api';
import { suitableAreas } from '../../../../data/suitableAreasData';

interface SuitableAreasProps {
  selectedCrop: string;
  weatherData?: WeatherData;
  soilData?: SoilParameters;
  weatherLoading?: boolean;
  soilLoading?: boolean;
  weatherError?: string | null;
  soilError?: string | null;
}

const SuitableAreas: React.FC<SuitableAreasProps> = ({ 
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
          <MapPin className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Suitable Areas: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-emerald-600">
            <Loader2 className="w-5 h-5 animate-spin" />
            Loading area data...
          </div>
        </div>
      </div>
    );
  }

  if (hasError) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <MapPin className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Suitable Areas: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading area data
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <MapPin className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Suitable Areas: {selectedCrop}</h4>
      </div>

      {/* Current Location Info */}
      {weatherData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Current Location Analysis</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Location:</span>
              <p className="text-gray-600">{weatherData.location.name}, {weatherData.location.country}</p>
            </div>
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
          </div>
        </div>
      )}

      {/* Soil Context */}
      {soilData && (
        <div className="bg-green-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-green-600 mb-2">Soil Analysis</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Soil Type:</span>
              <p className="text-gray-600">{soilData.soil_type || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">pH Level:</span>
              <p className="text-gray-600">{soilData.ph || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">Organic Matter:</span>
              <p className="text-gray-600">{soilData.organic_matter || 'Not available'}%</p>
            </div>
            <div>
              <span className="font-medium">Water Holding:</span>
              <p className="text-gray-600">{soilData.water_holding_capacity || 'Not available'}</p>
            </div>
          </div>
      </div>
      )}

      {/* Suitable Areas Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {suitableAreas.map((area, index) => (
          <div key={index} className="bg-white rounded-lg p-4 border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <h5 className="font-semibold text-gray-800">{area.name}</h5>
              <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                area.climate === 'Hot' || area.climate === 'Very Hot'
                  ? 'bg-red-100 text-red-600'
                  : area.climate === 'Medium'
                  ? 'bg-yellow-100 text-yellow-600'
                  : 'bg-green-100 text-green-600'
              }`}>
                {area.climate}
              </span>
            </div>
            <p className="text-sm text-gray-600">{area.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default SuitableAreas;
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-emerald-600">
            <Loader2 className="w-5 h-5 animate-spin" />
            Loading area data...
          </div>
        </div>
      </div>
    );
  }

  if (hasError) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <MapPin className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Suitable Areas: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading area data
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <MapPin className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Suitable Areas: {selectedCrop}</h4>
      </div>

      {/* Current Location Info */}
      {weatherData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Current Location Analysis</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Location:</span>
              <p className="text-gray-600">{weatherData.location.name}, {weatherData.location.country}</p>
            </div>
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
          </div>
        </div>
      )}

      {/* Soil Context */}
      {soilData && (
        <div className="bg-green-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-green-600 mb-2">Soil Analysis</h5>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span className="font-medium">Soil Type:</span>
              <p className="text-gray-600">{soilData.soil_type || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">pH Level:</span>
              <p className="text-gray-600">{soilData.ph || 'Not available'}</p>
            </div>
            <div>
              <span className="font-medium">Organic Matter:</span>
              <p className="text-gray-600">{soilData.organic_matter || 'Not available'}%</p>
            </div>
            <div>
              <span className="font-medium">Water Holding:</span>
              <p className="text-gray-600">{soilData.water_holding_capacity || 'Not available'}</p>
            </div>
          </div>
      </div>
      )}

      {/* Suitable Areas Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {suitableAreas.map((area, index) => (
          <div key={index} className="bg-white rounded-lg p-4 border border-gray-200">
            <div className="flex items-center justify-between mb-2">
              <h5 className="font-semibold text-gray-800">{area.name}</h5>
              <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                area.climate === 'Hot' || area.climate === 'Very Hot'
                  ? 'bg-red-100 text-red-600'
                  : area.climate === 'Medium'
                  ? 'bg-yellow-100 text-yellow-600'
                  : 'bg-green-100 text-green-600'
              }`}>
                {area.climate}
              </span>
            </div>
            <p className="text-sm text-gray-600">{area.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default SuitableAreas;