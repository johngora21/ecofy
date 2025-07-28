import React, { useState, useMemo } from 'react';
import MarketplaceHeader from './sections/MarketplaceHeader';
import MarketplaceFilters from './sections/MarketplaceFilters';
import ProductGrid from './sections/ProductGrid';
import MarketPriceView from './sections/MarketPriceView';
import type { MarketplaceTab, MarketFilters, FilterOptions, MarketItem as BaseMarketItem } from '../../../types/marketplace';
import { useMarketData } from '../../../hooks/useApi';

type MarketItem = BaseMarketItem & { quantity?: number };



const Marketplace: React.FC = () => {
  const [activeTab, setActiveTab] = useState<MarketplaceTab>('all-products');
  const [filters, setFilters] = useState<MarketFilters>({
    location: 'Arusha',
    product: 'Maize',
    unit: 'Kilogram (kg)',
    timePeriod: '3 Months',
    search: '',
    category: 'All Categories'
  });

  const [cart, setCart] = useState<MarketItem[]>([]);

  // Use real market data from API
  const { data: marketData, loading: marketLoading, error: marketError, refetch: refetchMarket } = useMarketData();

  const handleAddToCart = (item: MarketItem) => {
    setCart(prev => {
      const existingItem = prev.find(cartItem => cartItem.id === item.id);
      if (existingItem) {
        return prev.map(cartItem =>
          cartItem.id === item.id
            ? { ...cartItem, quantity: (cartItem.quantity || 1) + 1 }
            : cartItem
        );
      }
      return [...prev, { ...item, quantity: 1 }];
    });
  };

  // Use API data if available, otherwise use fallback data
  const convertedMarketData: MarketItem[] = useMemo(() => {
    if (marketData && marketData.length > 0) {
      return marketData.map(item => ({
        id: item.id,
        name: item.name,
        price: item.price,
        unit: item.unit,
        description: item.description,
        location: item.location,
        category: item.category,
        image: item.image
      }));
    }
    
    // Return empty array when API is not available
    return [];
  }, [marketData]);

  const filteredItems = useMemo(() => {
    if (!convertedMarketData.length) return [];

    return convertedMarketData.filter(item => {
      // Filter by tab
      if (activeTab !== 'market-price' && activeTab !== 'all-products') {
        if (item.category !== activeTab) return false;
      }

      // Filter by location
      if (filters.location && filters.location !== 'All Locations') {
        if (item.location !== filters.location) return false;
      }

      // Filter by product
      if (filters.product && filters.product !== 'All Products') {
        if (!item.name.toLowerCase().includes(filters.product.toLowerCase())) return false;
      }

      // Filter by category
      if (filters.category && filters.category !== 'All Categories') {
        if (item.category !== filters.category.toLowerCase()) return false;
      }

      // Filter by search
      if (filters.search) {
        const searchTerm = filters.search.toLowerCase();
        if (!item.name.toLowerCase().includes(searchTerm) &&
            !item.description.toLowerCase().includes(searchTerm) &&
            !item.location.toLowerCase().includes(searchTerm)) {
          return false;
        }
      }

      return true;
    });
  }, [activeTab, filters, convertedMarketData]);

  // Generate filter options from data
  const filterOptions: FilterOptions = useMemo(() => {
    const locations = ['All Locations', ...Array.from(new Set(convertedMarketData.map(item => item.location)))];
    const products = ['All Products', ...Array.from(new Set(convertedMarketData.map(item => item.name)))];
    const units = ['All Units', ...Array.from(new Set(convertedMarketData.map(item => item.unit)))];
    const categories = ['All Categories', ...Array.from(new Set(convertedMarketData.map(item => item.category)))];
    const timePeriods = ['1 Month', '3 Months', '6 Months', '1 Year'];

    return {
      location: locations,
      product: products,
      unit: units,
      timePeriod: timePeriods,
      category: categories
    };
  }, [convertedMarketData]);

  // Show loading state
  if (marketLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading marketplace data...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <MarketplaceHeader
        activeTab={activeTab}
        onTabChange={setActiveTab}
      />
      
      {/* Show notification when API is unavailable */}
      {marketError && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mx-6 mt-4">
          <div className="flex items-center gap-2 text-yellow-800">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
            <span className="text-sm">Marketplace data unavailable - connect to backend API</span>
          </div>
        </div>
      )}
      
      <MarketplaceFilters
        activeTab={activeTab}
        filters={filters}
        filterOptions={filterOptions}
        onFiltersChange={setFilters}
      />

      <div className="bg-gray-50">
        {activeTab === 'market-price' ? (
          <MarketPriceView filters={filters} />
        ) : (
          <ProductGrid
            items={filteredItems}
            onAddToCart={handleAddToCart}
          />
        )}
      </div>

      {/* Cart indicator (optional) */}
      {cart.length > 0 && (
        <div className="fixed bottom-4 right-4 bg-green-500 text-white rounded-full p-3 shadow-lg">
          <span className="text-sm font-medium">
            Cart ({cart.reduce((sum, item) => sum + (item.quantity || 1), 0)})
          </span>
        </div>
      )}
    </div>
  );
};

export default Marketplace;