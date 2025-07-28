export type Page = 'dashboard' | 'farms' | 'resources' | 'marketplace' | 'orders';

export type ActiveSection = 'market' | 'soil' | 'risks' | 'areas' | 'climate';

export interface MarketDataPoint {
  month: string;
  price: number;
}

export interface SoilDataPoint {
  parameter: string;
  value: number;
  optimalRange: string;
}

export interface Risk {
  name: string;
  level: 'High Risk' | 'Medium Risk' | 'Low Risk';
  description: string;
  color: string;
}

export interface RiskCategory {
  category: string;
  risks: Risk[];
}

export interface SuitableArea {
  name: string;
  climate: string;
  description: string;
}

export interface DashboardProps {
  selectedCrop: string;
  setSelectedCrop: (crop: string) => void;
}

export interface SectionProps {
  selectedCrop: string;
}