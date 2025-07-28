export type MarketplaceTab = 'market-price' | 'all-products' | 'crops' | 'livestock' | 'poultry' | 'fisheries' | 'seeds' | 'fertilizers' | 'equipment';

export interface MarketItem {
  id: string;
  name: string;
  price: number;
  unit: string;
  location: string;
  description: string;
  image?: string;
  category: string;
}

export interface FilterOptions {
  location: string[];
  product?: string[];
  unit: string[];
  timePeriod: string[];
  category?: string[];
}

export interface MarketFilters {
  location: string;
  product?: string;
  unit: string;
  timePeriod: string;
  category?: string;
  search: string;
}

export interface ChartData {
  month: string;
  price: number;
}

export interface PriceStats {
  current: number;
  average: number;
  highest: number;
  lowest: number;
  volatility: 'Low' | 'Medium' | 'High';
}