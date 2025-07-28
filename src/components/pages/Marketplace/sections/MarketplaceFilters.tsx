import React from 'react';
import { Search, Filter, Bell, Download, Share2 } from 'lucide-react';
import type { MarketplaceTab, MarketFilters, FilterOptions } from '../../../../types/marketplace';

interface MarketplaceFiltersProps {
  activeTab: MarketplaceTab;
  filters: MarketFilters;
  filterOptions: FilterOptions;
  onFiltersChange: (filters: MarketFilters) => void;
}

const MarketplaceFilters: React.FC<MarketplaceFiltersProps> = ({
  activeTab,
  filters,
  filterOptions,
  onFiltersChange
}) => {
  const handleFilterChange = (key: keyof MarketFilters, value: string) => {
    onFiltersChange({
      ...filters,
      [key]: value
    });
  };

  const renderFilters = () => {
    if (activeTab === 'market-price') {
      return (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <div>
            <label className="block text-sm text-gray-600 mb-1">Location</label>
            <select
              className="w-full border border-gray-300 rounded-lg px-3 py-2 bg-white"
              value={filters.location}
              onChange={(e) => handleFilterChange('location', e.target.value)}
            >
              {filterOptions.location.map(location => (
                <option key={location} value={location}>{location}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm text-gray-600 mb-1">Product</label>
            <select
              className="w-full border border-gray-300 rounded-lg px-3 py-2 bg-white"
              value={filters.product || ''}
              onChange={(e) => handleFilterChange('product', e.target.value)}
            >
              {filterOptions.product?.map(product => (
                <option key={product} value={product}>{product}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm text-gray-600 mb-1">Unit</label>
            <select
              className="w-full border border-gray-300 rounded-lg px-3 py-2 bg-white"
              value={filters.unit}
              onChange={(e) => handleFilterChange('unit', e.target.value)}
            >
              {filterOptions.unit.map(unit => (
                <option key={unit} value={unit}>{unit}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm text-gray-600 mb-1">Time Period</label>
            <select
              className="w-full border border-gray-300 rounded-lg px-3 py-2 bg-white"
              value={filters.timePeriod}
              onChange={(e) => handleFilterChange('timePeriod', e.target.value)}
            >
              {filterOptions.timePeriod.map(period => (
                <option key={period} value={period}>{period}</option>
              ))}
            </select>
          </div>
        </div>
      );
    } else {
      // For other tabs, show category-specific filters
      return (
        <div className="mb-6">
          <div className="flex gap-4 mb-4 flex-wrap">
            <select
              className="border border-gray-300 rounded-lg px-4 py-2 bg-white min-w-32"
              value={filters.category || filters.product || 'All'}
              onChange={(e) => {
                if (activeTab === 'all-products') {
                  handleFilterChange('category', e.target.value);
                } else {
                  handleFilterChange('product', e.target.value);
                }
              }}
            >
              {activeTab === 'all-products' && filterOptions.category?.map(category => (
                <option key={category} value={category}>{category}</option>
              ))}
              {activeTab !== 'all-products' && filterOptions.product?.map(product => (
                <option key={product} value={product}>{product}</option>
              ))}
            </select>

            <select 
              className="border border-gray-300 rounded-lg px-4 py-2 bg-white min-w-32"
              value={filters.location}
              onChange={(e) => handleFilterChange('location', e.target.value)}
            >
              {filterOptions.location.map(location => (
                <option key={location} value={location}>{location}</option>
              ))}
            </select>
            
            <select 
              className="border border-gray-300 rounded-lg px-4 py-2 bg-white min-w-32"
              value={filters.unit}
              onChange={(e) => handleFilterChange('unit', e.target.value)}
            >
              {filterOptions.unit.map(unit => (
                <option key={unit} value={unit}>{unit}</option>
              ))}
            </select>
          </div>
        </div>
      );
    }
  };

  return (
    <div className="bg-white p-6 border-b">
      {renderFilters()}
      
      <div className="flex gap-4 mb-6">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Search..."
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg bg-white"
              value={filters.search}
              onChange={(e) => handleFilterChange('search', e.target.value)}
            />
          </div>
        </div>
        <button className="border border-gray-300 px-4 py-2 rounded-lg flex items-center gap-2 bg-white hover:bg-gray-50">
          <Filter size={16} />
        </button>
        <button className="border border-gray-300 px-4 py-2 rounded-lg flex items-center gap-2 bg-white hover:bg-gray-50">
          <Bell size={16} />
          Set Alerts
        </button>
        <button className="border border-gray-300 px-4 py-2 rounded-lg flex items-center gap-2 bg-white hover:bg-gray-50">
          <Download size={16} />
          Download
        </button>
        <button className="border border-gray-300 px-4 py-2 rounded-lg flex items-center gap-2 bg-white hover:bg-gray-50">
          <Share2 size={16} />
          Share
        </button>
      </div>
    </div>
  );
};

export default MarketplaceFilters;