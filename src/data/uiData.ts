export interface TabConfig {
  id: string;
  label: string;
}

export interface ProductOption {
  value: string;
  label: string;
}

export interface LocationOption {
  value: string;
  label: string;
}

export interface TimePeriodOption {
  value: string;
  label: string;
}

// Marketplace tabs configuration
export const marketplaceTabs: TabConfig[] = [
  { id: 'market-price', label: 'Market Price' },
  { id: 'all-products', label: 'All Products' },
  { id: 'crops', label: 'Crops' },
  { id: 'livestock', label: 'Livestock' },
  { id: 'poultry', label: 'Poultry' },
  { id: 'fisheries', label: 'Fisheries' },
  { id: 'seeds', label: 'Seeds' },
  { id: 'fertilizers', label: 'Fertilizers' },
  { id: 'equipment', label: 'Equipment' }
];

// Market price view sub-tabs
export const marketPriceSubTabs: TabConfig[] = [
  { id: 'crop-prices', label: 'Crop Prices' },
  { id: 'input-prices', label: 'Input Prices' },
  { id: 'regional', label: 'Regional' },
  { id: 'news', label: 'News' }
];

// Resources tabs configuration
export const resourcesTabs: TabConfig[] = [
  { id: 'tutorials', label: 'Tutorials' },
  { id: 'events', label: 'Events' },
  { id: 'business-plan', label: 'AI Business Plan' },
  { id: 'books', label: 'Books' }
];

// Product options
export const productOptions: ProductOption[] = [
  { value: 'All Products', label: 'All Products' },
  { value: 'Maize', label: 'Maize' },
  { value: 'Rice', label: 'Rice' },
  { value: 'Cattle', label: 'Cattle' },
  { value: 'Poultry', label: 'Poultry' },
  { value: 'Fisheries', label: 'Fisheries' },
  { value: 'Seeds', label: 'Seeds' },
  { value: 'Fertilizers', label: 'Fertilizers' },
  { value: 'Equipment', label: 'Equipment' }
];

// Location options
export const locationOptions: LocationOption[] = [
  { value: 'All Locations', label: 'All Locations' },
  { value: 'Arusha', label: 'Arusha' },
  { value: 'Dar es Salaam', label: 'Dar es Salaam' },
  { value: 'Dodoma', label: 'Dodoma' },
  { value: 'Mbeya', label: 'Mbeya' },
  { value: 'Morogoro', label: 'Morogoro' },
  { value: 'Mwanza', label: 'Mwanza' },
  { value: 'Tanga', label: 'Tanga' },
  { value: 'Iringa', label: 'Iringa' },
  { value: 'Tabora', label: 'Tabora' },
  { value: 'Kigoma', label: 'Kigoma' }
];

// Time period options
export const timePeriodOptions: TimePeriodOption[] = [
  { value: '1 Month', label: '1 Month' },
  { value: '3 Months', label: '3 Months' },
  { value: '6 Months', label: '6 Months' },
  { value: '1 Year', label: '1 Year' }
];

// Event type options
export const eventTypeOptions: ProductOption[] = [
  { value: 'All Types', label: 'All Types' },
  { value: 'Workshop', label: 'Workshop' },
  { value: 'Conference', label: 'Conference' },
  { value: 'Training', label: 'Training' },
  { value: 'Exhibition', label: 'Exhibition' }
];

// Farm view tabs
export const farmViewTabs: string[] = ['Farm Maps', 'Soil Reports', 'Resources', 'Recommendations']; 
 
 
  id: string;
  label: string;
}

export interface ProductOption {
  value: string;
  label: string;
}

export interface LocationOption {
  value: string;
  label: string;
}

export interface TimePeriodOption {
  value: string;
  label: string;
}

// Marketplace tabs configuration
export const marketplaceTabs: TabConfig[] = [
  { id: 'market-price', label: 'Market Price' },
  { id: 'all-products', label: 'All Products' },
  { id: 'crops', label: 'Crops' },
  { id: 'livestock', label: 'Livestock' },
  { id: 'poultry', label: 'Poultry' },
  { id: 'fisheries', label: 'Fisheries' },
  { id: 'seeds', label: 'Seeds' },
  { id: 'fertilizers', label: 'Fertilizers' },
  { id: 'equipment', label: 'Equipment' }
];

// Market price view sub-tabs
export const marketPriceSubTabs: TabConfig[] = [
  { id: 'crop-prices', label: 'Crop Prices' },
  { id: 'input-prices', label: 'Input Prices' },
  { id: 'regional', label: 'Regional' },
  { id: 'news', label: 'News' }
];

// Resources tabs configuration
export const resourcesTabs: TabConfig[] = [
  { id: 'tutorials', label: 'Tutorials' },
  { id: 'events', label: 'Events' },
  { id: 'business-plan', label: 'AI Business Plan' },
  { id: 'books', label: 'Books' }
];

// Product options
export const productOptions: ProductOption[] = [
  { value: 'All Products', label: 'All Products' },
  { value: 'Maize', label: 'Maize' },
  { value: 'Rice', label: 'Rice' },
  { value: 'Cattle', label: 'Cattle' },
  { value: 'Poultry', label: 'Poultry' },
  { value: 'Fisheries', label: 'Fisheries' },
  { value: 'Seeds', label: 'Seeds' },
  { value: 'Fertilizers', label: 'Fertilizers' },
  { value: 'Equipment', label: 'Equipment' }
];

// Location options
export const locationOptions: LocationOption[] = [
  { value: 'All Locations', label: 'All Locations' },
  { value: 'Arusha', label: 'Arusha' },
  { value: 'Dar es Salaam', label: 'Dar es Salaam' },
  { value: 'Dodoma', label: 'Dodoma' },
  { value: 'Mbeya', label: 'Mbeya' },
  { value: 'Morogoro', label: 'Morogoro' },
  { value: 'Mwanza', label: 'Mwanza' },
  { value: 'Tanga', label: 'Tanga' },
  { value: 'Iringa', label: 'Iringa' },
  { value: 'Tabora', label: 'Tabora' },
  { value: 'Kigoma', label: 'Kigoma' }
];

// Time period options
export const timePeriodOptions: TimePeriodOption[] = [
  { value: '1 Month', label: '1 Month' },
  { value: '3 Months', label: '3 Months' },
  { value: '6 Months', label: '6 Months' },
  { value: '1 Year', label: '1 Year' }
];

// Event type options
export const eventTypeOptions: ProductOption[] = [
  { value: 'All Types', label: 'All Types' },
  { value: 'Workshop', label: 'Workshop' },
  { value: 'Conference', label: 'Conference' },
  { value: 'Training', label: 'Training' },
  { value: 'Exhibition', label: 'Exhibition' }
];

// Farm view tabs
export const farmViewTabs: string[] = ['Farm Maps', 'Soil Reports', 'Resources', 'Recommendations']; 
 
 