import React, { useState } from 'react';
import { TrendingUp, Calendar } from 'lucide-react';
import CropPricesTab from './CropPricesTab';
import InputPrice from './InputPricesTab';
import RegionalTab from './RegionalTab';
import NewsTab from './NewsTab';
import type { MarketFilters } from './types';
import { marketPriceSubTabs } from '../../../../data/uiData';

interface MarketPriceViewProps {
  filters: MarketFilters;
}

const MarketPriceView: React.FC<MarketPriceViewProps> = ({ filters }) => {
  const [activeSubTab, setActiveSubTab] = useState('crop-prices');

  // Function to render the active tab content
  const renderTabContent = () => {
    switch (activeSubTab) {
      case 'crop-prices':
        return <CropPricesTab filters={filters} />;
      case 'input-prices':
        return <InputPrice filters={filters} />;
      case 'regional':
        return <RegionalTab filters={filters} />;
      case 'news':
        return <NewsTab />;
      default:
        return (
          <div className="flex items-center justify-center py-16">
            <div className="text-center">
              <div className="text-gray-400 text-6xl mb-4">📊</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">No price data available</h3>
              <p className="text-gray-500">Price data will be loaded from the backend API</p>
            </div>
          </div>
        );
    }
  };

  return (
    <div className="space-y-6">
      {/* Sub-tabs */}
      <div className="bg-white border border-gray-200 rounded-lg">
        <div className="flex border-b border-gray-200">
          {marketPriceSubTabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveSubTab(tab.id)}
              className={`flex-1 px-4 py-3 text-sm font-medium transition-colors ${
                activeSubTab === tab.id
                  ? 'text-green-600 border-b-2 border-green-600 bg-green-50'
                  : 'text-gray-600 hover:text-gray-800 hover:bg-gray-50'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Tab content */}
        {renderTabContent()}
    </div>
  );
};

export default MarketPriceView;