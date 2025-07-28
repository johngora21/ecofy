import { TrendingUp, BarChart3, AlertTriangle, MapPin, Cloud } from 'lucide-react';

export interface NavigationButton {
  key: string;
  icon: any;
  label: string;
}

export const navigationButtons: NavigationButton[] = [
  { key: 'market', icon: TrendingUp, label: 'Market Intelligence' },
  { key: 'soil', icon: BarChart3, label: 'Soil Insights' },
  { key: 'risks', icon: AlertTriangle, label: 'Risks' },
  { key: 'areas', icon: MapPin, label: 'Suitable Areas' },
  { key: 'climate', icon: Cloud, label: 'Climate Type' }
]; 
 
 

export interface NavigationButton {
  key: string;
  icon: any;
  label: string;
}

export const navigationButtons: NavigationButton[] = [
  { key: 'market', icon: TrendingUp, label: 'Market Intelligence' },
  { key: 'soil', icon: BarChart3, label: 'Soil Insights' },
  { key: 'risks', icon: AlertTriangle, label: 'Risks' },
  { key: 'areas', icon: MapPin, label: 'Suitable Areas' },
  { key: 'climate', icon: Cloud, label: 'Climate Type' }
]; 
 
 