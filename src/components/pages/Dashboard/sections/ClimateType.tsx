import React from 'react';
import { Cloud } from 'lucide-react';

interface ClimateTypeProps {
  selectedCrop: string;
}

const ClimateType: React.FC<ClimateTypeProps> = ({ selectedCrop }) => {
  return (
    <div className="bg-gray-50 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-6">
        <Cloud className="text-emerald-500" size={20} />
        <h4 className="font-semibold">Climate Type: {selectedCrop}</h4>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div>
          <h5 className="font-semibold text-gray-800 mb-4">Optimal Climate Conditions</h5>
          <div className="space-y-4">
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-sm font-medium">Temperature</span>
                <span className="text-sm text-gray-600">25-30°C</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-emerald-500 h-2 rounded-full" style={{width: '75%'}}></div>
              </div>
            </div>
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-sm font-medium">Rainfall</span>
                <span className="text-sm text-gray-600">500-800mm/year</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-emerald-500 h-2 rounded-full" style={{width: '60%'}}></div>
              </div>
            </div>
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-sm font-medium">Humidity</span>
                <span className="text-sm text-gray-600">40-60%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-emerald-500 h-2 rounded-full" style={{width: '50%'}}></div>
              </div>
            </div>
            <div>
              <div className="flex justify-between mb-1">
                <span className="text-sm font-medium">Growing Season</span>
                <span className="text-sm text-gray-600">90-120 days</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-emerald-500 h-2 rounded-full" style={{width: '90%'}}></div>
              </div>
            </div>
          </div>
        </div>

        <div>
          <div className="bg-white rounded-lg p-4 mb-4">
            <h6 className="font-semibold text-emerald-600 mb-2">Climate Overview</h6>
            <p className="text-gray-700 text-sm">
              Maize thrives in warm climate with moderate rainfall. It requires a long, frost-free growing 
              season and consistent moisture.
            </p>
          </div>

          <div className="bg-white rounded-lg p-4">
            <h6 className="font-semibold text-emerald-600 mb-2">AI Recommendation</h6>
            <p className="text-gray-700 text-sm">
              Based on your location in Tanzania, the climate is generally suitable for this product with 
              some adaptations. Consider planting in early March to align with rainfall patterns.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ClimateType;