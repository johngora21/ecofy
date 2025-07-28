import React from 'react';
import { AlertTriangle, Loader2, AlertCircle } from 'lucide-react';
import type { WeatherData, SoilParameters } from '../../../../services/api';
import { riskData } from '../../../../data/riskData';

interface RisksProps {
  selectedCrop: string;
  weatherData?: WeatherData;
  soilData?: SoilParameters;
  weatherLoading?: boolean;
  soilLoading?: boolean;
  weatherError?: string | null;
  soilError?: string | null;
}

const Risks: React.FC<RisksProps> = ({ 
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
          <AlertTriangle className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Risks: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-emerald-600">
            <Loader2 className="w-5 h-5 animate-spin" />
            Loading risk data...
          </div>
        </div>
      </div>
    );
  }

  if (hasError) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <AlertTriangle className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Risks: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading risk data
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <AlertTriangle className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Risks: {selectedCrop}</h4>
      </div>

      {/* Current Conditions Context */}
      {weatherData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Current Conditions Context</h5>
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

      {/* Risk Categories */}
      <div className="space-y-6">
      {riskData.map((category, categoryIndex) => (
          <div key={categoryIndex} className="bg-white rounded-lg p-4 border border-gray-200">
            <h5 className="font-semibold text-gray-800 mb-4">{category.category}</h5>
            <div className="space-y-4">
            {category.risks.map((risk, riskIndex) => (
                <div key={riskIndex} className={`p-4 rounded-lg border ${risk.color}`}>
                  <div className="flex items-start justify-between mb-2">
                    <h6 className="font-semibold text-gray-800">{risk.name}</h6>
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                      risk.level.includes('High')
                        ? 'bg-red-100 text-red-600'
                        : risk.level.includes('Medium')
                        ? 'bg-yellow-100 text-yellow-600'
                        : 'bg-green-100 text-green-600'
                  }`}>
                    {risk.level}
                  </span>
                </div>
                  <p className="text-sm text-gray-600">{risk.description}</p>
              </div>
            ))}
          </div>
        </div>
      ))}
      </div>

      {/* Risk Mitigation Recommendations */}
      <div className="mt-6 bg-emerald-50 rounded-lg p-4">
        <h5 className="font-semibold text-emerald-600 mb-2">Risk Mitigation Strategies</h5>
        <div className="text-sm text-gray-700 space-y-2">
          <p>• Implement integrated pest management (IPM) practices</p>
          <p>• Diversify crops to reduce market dependency</p>
          <p>• Invest in irrigation systems for drought resilience</p>
          <p>• Regular monitoring and early warning systems</p>
          <p>• Consider crop insurance for financial protection</p>
        </div>
      </div>
    </div>
  );
};

export default Risks;
    );
  }

  if (hasError) {
    return (
      <div className="bg-gray-50 rounded-lg p-6">
        <div className="flex items-center gap-2 mb-6">
          <AlertTriangle className="text-emerald-500" size={20} />
          <h4 className="font-semibold">Risks: {selectedCrop}</h4>
        </div>
        <div className="flex items-center justify-center h-64">
          <div className="flex items-center gap-2 text-red-600">
            <AlertCircle className="w-5 h-5" />
            Error loading risk data
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <AlertTriangle className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Risks: {selectedCrop}</h4>
      </div>

      {/* Current Conditions Context */}
      {weatherData && (
        <div className="bg-blue-50 rounded-lg p-4 mb-6">
          <h5 className="font-semibold text-blue-600 mb-2">Current Conditions Context</h5>
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

      {/* Risk Categories */}
      <div className="space-y-6">
      {riskData.map((category, categoryIndex) => (
          <div key={categoryIndex} className="bg-white rounded-lg p-4 border border-gray-200">
            <h5 className="font-semibold text-gray-800 mb-4">{category.category}</h5>
            <div className="space-y-4">
            {category.risks.map((risk, riskIndex) => (
                <div key={riskIndex} className={`p-4 rounded-lg border ${risk.color}`}>
                  <div className="flex items-start justify-between mb-2">
                    <h6 className="font-semibold text-gray-800">{risk.name}</h6>
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                      risk.level.includes('High')
                        ? 'bg-red-100 text-red-600'
                        : risk.level.includes('Medium')
                        ? 'bg-yellow-100 text-yellow-600'
                        : 'bg-green-100 text-green-600'
                  }`}>
                    {risk.level}
                  </span>
                </div>
                  <p className="text-sm text-gray-600">{risk.description}</p>
              </div>
            ))}
          </div>
        </div>
      ))}
      </div>

      {/* Risk Mitigation Recommendations */}
      <div className="mt-6 bg-emerald-50 rounded-lg p-4">
        <h5 className="font-semibold text-emerald-600 mb-2">Risk Mitigation Strategies</h5>
        <div className="text-sm text-gray-700 space-y-2">
          <p>• Implement integrated pest management (IPM) practices</p>
          <p>• Diversify crops to reduce market dependency</p>
          <p>• Invest in irrigation systems for drought resilience</p>
          <p>• Regular monitoring and early warning systems</p>
          <p>• Consider crop insurance for financial protection</p>
        </div>
      </div>
    </div>
  );
};

export default Risks;