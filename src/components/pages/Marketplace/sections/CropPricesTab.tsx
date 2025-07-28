import React from 'react';
import type { MarketFilters } from './types';

interface CropPricesTabProps {
  filters: MarketFilters;
}

const CropPricesTab: React.FC<CropPricesTabProps> = ({ filters }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">📊</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">Crop Price Data</h3>
        <p className="text-gray-500">Price data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default CropPricesTab;