// types/index.ts

export interface MarketFilters {
  location: string;
  product?: string;
  unit: string;
  timePeriod: string;
  search?: string;
  category?: string;
}

export interface PriceData {
  month: string;
  price: number;
  forecast?: number;
}

export interface PriceStats {
  current: number;
  average: number;
  highest: number;
  lowest: number;
  volatility: string;
  change: number;
}

export interface InputPrice {
  type: string;
  price: number;
  unit: string;
  change: number;
  location: string;
}

export interface RegionalPrice {
  region: string;
  price: number;
  change: number;
  supply: number;
  demand: number;
}

export interface NewsItem {
  id: string;
  title: string;
  description: string;
  priority: 'High Priority' | 'Medium Priority' | 'Low Priority';
  date: string;
  marketImpact: string;
}

export interface MarketPriceViewProps {
  filters: MarketFilters;
}