import React from 'react';
import { marketplaceTabs } from '../../../../data/uiData';
import type { MarketplaceTab } from './types';

interface MarketplaceHeaderProps {
  activeTab: MarketplaceTab;
  onTabChange: (tab: MarketplaceTab) => void;
}

const MarketplaceHeader: React.FC<MarketplaceHeaderProps> = ({ activeTab, onTabChange }) => {
  return (
    <div className="bg-white border-b border-gray-200">
      <div className="px-6 py-4">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Marketplace</h1>
            <p className="text-gray-600">Discover agricultural products and market insights</p>
          </div>
        </div>
        
        <div className="flex gap-1 mt-6 overflow-x-auto">
          {marketplaceTabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id as MarketplaceTab)}
              className={`px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap transition-colors ${
                activeTab === tab.id
                  ? 'bg-emerald-500 text-white'
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default MarketplaceHeader;