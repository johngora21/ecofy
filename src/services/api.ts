const API_BASE_URL = 'http://localhost:8000/api';

// Types for API responses
export interface WeatherData {
  current: {
    temp: number;
    humidity: number;
    wind_speed: number;
    weather: Array<{
      main: string;
      description: string;
    }>;
    last_updated: string;
  };
  location: {
    name: string;
    region: string;
    country: string;
    lat: number;
    lon: number;
    tz_id: string;
    localtime: string;
  };
  alerts: any[];
}

export interface SoilParameters {
  moisture: string;
  organic_carbon: string;
  texture: string;
  ph: string;
  ec: string;
  salinity: string;
  water_holding: string;
  organic_matter: string;
  npk: string;
}

export interface CropData {
  id: string;
  name: string;
  description: string;
  optimal_planting_time: string;
  image: string;
  climate_requirements?: any;
  soil_requirements?: any;
  risks?: any;
}

export interface MarketData {
  id: string;
  name: string;
  price: number;
  unit: string;
  description: string;
  location: string;
  category: string;
  image: string;
}

export interface FarmData {
  id: string;
  name: string;
  location: string;
  size: number;
  soil_type: string;
  crops: string[];
  created_at: string;
}

// Generic API client
class ApiClient {
  private baseURL: string;

  constructor(baseURL: string) {
    this.baseURL = baseURL;
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseURL}${endpoint}`;
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // Weather API
  async getWeatherForecast(lat: number, lng: number): Promise<WeatherData> {
    return this.request<WeatherData>(`/weather/forecast?lat=${lat}&lng=${lng}`);
  }

  // Soil API
  async getSoilData(lat: number, lng: number): Promise<SoilParameters> {
    return this.request<SoilParameters>(`/satellite/soil?lat=${lat}&lng=${lng}`);
  }

  // Crops API
  async getCrops(page: number = 1, limit: number = 10, name?: string): Promise<{
    items: CropData[];
    total: number;
    page: number;
    pages: number;
  }> {
    let endpoint = `/crops?page=${page}&limit=${limit}`;
    if (name) {
      endpoint += `&name=${encodeURIComponent(name)}`;
    }
    return this.request(endpoint);
  }

  async getCropById(cropId: string): Promise<CropData> {
    return this.request<CropData>(`/crops/${cropId}`);
  }

  async getCropRecommendations(cropId: string, farmId?: string): Promise<any> {
    let endpoint = `/crops/${cropId}/recommendations`;
    if (farmId) {
      endpoint += `?farm_id=${farmId}`;
    }
    return this.request(endpoint);
  }

  // Market API
  async getMarketData(): Promise<MarketData[]> {
    return this.request<MarketData[]>('/marketplace');
  }

  async getMarketPrices(): Promise<any> {
    return this.request('/market/prices');
  }

  // Farms API
  async getFarms(): Promise<FarmData[]> {
    return this.request<FarmData[]>('/farms');
  }

  async createFarm(farmData: Partial<FarmData>): Promise<FarmData> {
    return this.request<FarmData>('/farms', {
      method: 'POST',
      body: JSON.stringify(farmData),
    });
  }

  async updateFarm(farmId: string, farmData: Partial<FarmData>): Promise<FarmData> {
    return this.request<FarmData>(`/farms/${farmId}`, {
      method: 'PUT',
      body: JSON.stringify(farmData),
    });
  }

  async deleteFarm(farmId: string): Promise<void> {
    return this.request<void>(`/farms/${farmId}`, {
      method: 'DELETE',
    });
  }

  // Orders API
  async getOrders(): Promise<any[]> {
    return this.request<any[]>('/orders');
  }

  async createOrder(orderData: any): Promise<any> {
    return this.request<any>('/orders', {
      method: 'POST',
      body: JSON.stringify(orderData),
    });
  }

  // Authentication API
  async login(credentials: { email: string; password: string }): Promise<{ access_token: string; token_type: string }> {
    const formData = new FormData();
    formData.append('username', credentials.email);
    formData.append('password', credentials.password);

    return this.request<{ access_token: string; token_type: string }>('/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        username: credentials.email,
        password: credentials.password,
      }),
    });
  }

  async register(userData: {
    email: string;
    full_name: string;
    phone_number: string;
    location: string;
    preferred_language: string;
    password: string;
  }): Promise<any> {
    return this.request('/auth/register', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }
}

// Create and export the API client instance
export const apiClient = new ApiClient(API_BASE_URL);

// Export individual API functions for easier use
export const weatherAPI = {
  getForecast: (lat: number, lng: number) => apiClient.getWeatherForecast(lat, lng),
};

export const soilAPI = {
  getData: (lat: number, lng: number) => apiClient.getSoilData(lat, lng),
};

export const cropsAPI = {
  getAll: (page?: number, limit?: number, name?: string) => apiClient.getCrops(page, limit, name),
  getById: (id: string) => apiClient.getCropById(id),
  getRecommendations: (cropId: string, farmId?: string) => apiClient.getCropRecommendations(cropId, farmId),
};

export const marketAPI = {
  getData: () => apiClient.getMarketData(),
  getPrices: () => apiClient.getMarketPrices(),
};

export const farmsAPI = {
  getAll: () => apiClient.getFarms(),
  create: (data: Partial<FarmData>) => apiClient.createFarm(data),
  update: (id: string, data: Partial<FarmData>) => apiClient.updateFarm(id, data),
  delete: (id: string) => apiClient.deleteFarm(id),
};

export const ordersAPI = {
  getAll: () => apiClient.getOrders(),
  create: (data: any) => apiClient.createOrder(data),
};

export const authAPI = {
  login: (credentials: { email: string; password: string }) => apiClient.login(credentials),
  register: (userData: any) => apiClient.register(userData),
}; 
 

// Types for API responses
export interface WeatherData {
  current: {
    temp: number;
    humidity: number;
    wind_speed: number;
    weather: Array<{
      main: string;
      description: string;
    }>;
    last_updated: string;
  };
  location: {
    name: string;
    region: string;
    country: string;
    lat: number;
    lon: number;
    tz_id: string;
    localtime: string;
  };
  alerts: any[];
}

export interface SoilParameters {
  moisture: string;
  organic_carbon: string;
  texture: string;
  ph: string;
  ec: string;
  salinity: string;
  water_holding: string;
  organic_matter: string;
  npk: string;
}

export interface CropData {
  id: string;
  name: string;
  description: string;
  optimal_planting_time: string;
  image: string;
  climate_requirements?: any;
  soil_requirements?: any;
  risks?: any;
}

export interface MarketData {
  id: string;
  name: string;
  price: number;
  unit: string;
  description: string;
  location: string;
  category: string;
  image: string;
}

export interface FarmData {
  id: string;
  name: string;
  location: string;
  size: number;
  soil_type: string;
  crops: string[];
  created_at: string;
}

// Generic API client
class ApiClient {
  private baseURL: string;

  constructor(baseURL: string) {
    this.baseURL = baseURL;
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseURL}${endpoint}`;
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // Weather API
  async getWeatherForecast(lat: number, lng: number): Promise<WeatherData> {
    return this.request<WeatherData>(`/weather/forecast?lat=${lat}&lng=${lng}`);
  }

  // Soil API
  async getSoilData(lat: number, lng: number): Promise<SoilParameters> {
    return this.request<SoilParameters>(`/satellite/soil?lat=${lat}&lng=${lng}`);
  }

  // Crops API
  async getCrops(page: number = 1, limit: number = 10, name?: string): Promise<{
    items: CropData[];
    total: number;
    page: number;
    pages: number;
  }> {
    let endpoint = `/crops?page=${page}&limit=${limit}`;
    if (name) {
      endpoint += `&name=${encodeURIComponent(name)}`;
    }
    return this.request(endpoint);
  }

  async getCropById(cropId: string): Promise<CropData> {
    return this.request<CropData>(`/crops/${cropId}`);
  }

  async getCropRecommendations(cropId: string, farmId?: string): Promise<any> {
    let endpoint = `/crops/${cropId}/recommendations`;
    if (farmId) {
      endpoint += `?farm_id=${farmId}`;
    }
    return this.request(endpoint);
  }

  // Market API
  async getMarketData(): Promise<MarketData[]> {
    return this.request<MarketData[]>('/marketplace');
  }

  async getMarketPrices(): Promise<any> {
    return this.request('/market/prices');
  }

  // Farms API
  async getFarms(): Promise<FarmData[]> {
    return this.request<FarmData[]>('/farms');
  }

  async createFarm(farmData: Partial<FarmData>): Promise<FarmData> {
    return this.request<FarmData>('/farms', {
      method: 'POST',
      body: JSON.stringify(farmData),
    });
  }

  async updateFarm(farmId: string, farmData: Partial<FarmData>): Promise<FarmData> {
    return this.request<FarmData>(`/farms/${farmId}`, {
      method: 'PUT',
      body: JSON.stringify(farmData),
    });
  }

  async deleteFarm(farmId: string): Promise<void> {
    return this.request<void>(`/farms/${farmId}`, {
      method: 'DELETE',
    });
  }

  // Orders API
  async getOrders(): Promise<any[]> {
    return this.request<any[]>('/orders');
  }

  async createOrder(orderData: any): Promise<any> {
    return this.request<any>('/orders', {
      method: 'POST',
      body: JSON.stringify(orderData),
    });
  }

  // Authentication API
  async login(credentials: { email: string; password: string }): Promise<{ access_token: string; token_type: string }> {
    const formData = new FormData();
    formData.append('username', credentials.email);
    formData.append('password', credentials.password);

    return this.request<{ access_token: string; token_type: string }>('/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        username: credentials.email,
        password: credentials.password,
      }),
    });
  }

  async register(userData: {
    email: string;
    full_name: string;
    phone_number: string;
    location: string;
    preferred_language: string;
    password: string;
  }): Promise<any> {
    return this.request('/auth/register', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
  }
}

// Create and export the API client instance
export const apiClient = new ApiClient(API_BASE_URL);

// Export individual API functions for easier use
export const weatherAPI = {
  getForecast: (lat: number, lng: number) => apiClient.getWeatherForecast(lat, lng),
};

export const soilAPI = {
  getData: (lat: number, lng: number) => apiClient.getSoilData(lat, lng),
};

export const cropsAPI = {
  getAll: (page?: number, limit?: number, name?: string) => apiClient.getCrops(page, limit, name),
  getById: (id: string) => apiClient.getCropById(id),
  getRecommendations: (cropId: string, farmId?: string) => apiClient.getCropRecommendations(cropId, farmId),
};

export const marketAPI = {
  getData: () => apiClient.getMarketData(),
  getPrices: () => apiClient.getMarketPrices(),
};

export const farmsAPI = {
  getAll: () => apiClient.getFarms(),
  create: (data: Partial<FarmData>) => apiClient.createFarm(data),
  update: (id: string, data: Partial<FarmData>) => apiClient.updateFarm(id, data),
  delete: (id: string) => apiClient.deleteFarm(id),
};

export const ordersAPI = {
  getAll: () => apiClient.getOrders(),
  create: (data: any) => apiClient.createOrder(data),
};

export const authAPI = {
  login: (credentials: { email: string; password: string }) => apiClient.login(credentials),
  register: (userData: any) => apiClient.register(userData),
}; 
 