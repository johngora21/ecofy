import { useState, useEffect, useCallback } from 'react';
import { 
  weatherAPI, 
  soilAPI, 
  cropsAPI, 
  marketAPI, 
  farmsAPI, 
  ordersAPI, 
  authAPI,
  type WeatherData,
  type SoilParameters,
  type CropData,
  type MarketData,
  type FarmData
} from '../services/api';

// Generic API state hook
interface ApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

function useApiState<T>() {
  const [state, setState] = useState<ApiState<T>>({
    data: null,
    loading: false,
    error: null,
  });

  const setLoading = useCallback((loading: boolean) => {
    setState(prev => ({ ...prev, loading, error: null }));
  }, []);

  const setData = useCallback((data: T) => {
    setState({ data, loading: false, error: null });
  }, []);

  const setError = useCallback((error: string) => {
    setState({ data: null, loading: false, error });
  }, []);

  return { state, setLoading, setData, setError };
}

// Weather API hook
export function useWeatherData(lat: number, lng: number) {
  const { state, setLoading, setData, setError } = useApiState<WeatherData>();

  const fetchWeather = useCallback(async () => {
    if (!lat || !lng) return;
    
    setLoading(true);
    try {
      const data = await weatherAPI.getForecast(lat, lng);
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch weather data');
    }
  }, [lat, lng, setLoading, setData, setError]);

  useEffect(() => {
    fetchWeather();
  }, [fetchWeather]);

  return { ...state, refetch: fetchWeather };
}

// Soil API hook
export function useSoilData(lat: number, lng: number) {
  const { state, setLoading, setData, setError } = useApiState<SoilParameters>();

  const fetchSoil = useCallback(async () => {
    if (!lat || !lng) return;
    
    setLoading(true);
    try {
      const data = await soilAPI.getData(lat, lng);
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch soil data');
    }
  }, [lat, lng, setLoading, setData, setError]);

  useEffect(() => {
    fetchSoil();
  }, [fetchSoil]);

  return { ...state, refetch: fetchSoil };
}

// Crops API hook
export function useCrops(page: number = 1, limit: number = 10, name?: string) {
  const { state, setLoading, setData, setError } = useApiState<{
    items: CropData[];
    total: number;
    page: number;
    pages: number;
  }>();

  const fetchCrops = useCallback(async () => {
    setLoading(true);
    try {
      const data = await cropsAPI.getAll(page, limit, name);
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch crops data');
    }
  }, [page, limit, name, setLoading, setData, setError]);

  useEffect(() => {
    fetchCrops();
  }, [fetchCrops]);

  return { ...state, refetch: fetchCrops };
}

// Market API hook
export function useMarketData() {
  const { state, setLoading, setData, setError } = useApiState<MarketData[]>();

  const fetchMarket = useCallback(async () => {
    setLoading(true);
    try {
      const data = await marketAPI.getData();
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch market data');
    }
  }, [setLoading, setData, setError]);

  useEffect(() => {
    fetchMarket();
  }, [fetchMarket]);

  return { ...state, refetch: fetchMarket };
}

// Farms API hook
export function useFarms() {
  const { state, setLoading, setData, setError } = useApiState<FarmData[]>();

  const fetchFarms = useCallback(async () => {
    setLoading(true);
    try {
      const data = await farmsAPI.getAll();
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch farms data');
    }
  }, [setLoading, setData, setError]);

  useEffect(() => {
    fetchFarms();
  }, [fetchFarms]);

  const createFarm = useCallback(async (farmData: Partial<FarmData>) => {
    setLoading(true);
    try {
      const newFarm = await farmsAPI.create(farmData);
      setData(prev => prev ? [...prev, newFarm] : [newFarm]);
      return newFarm;
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to create farm');
      throw error;
    }
  }, [setLoading, setData, setError]);

  const updateFarm = useCallback(async (id: string, farmData: Partial<FarmData>) => {
    setLoading(true);
    try {
      const updatedFarm = await farmsAPI.update(id, farmData);
      setData(prev => prev ? prev.map(farm => farm.id === id ? updatedFarm : farm) : [updatedFarm]);
      return updatedFarm;
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to update farm');
      throw error;
    }
  }, [setLoading, setData, setError]);

  const deleteFarm = useCallback(async (id: string) => {
    setLoading(true);
    try {
      await farmsAPI.delete(id);
      setData(prev => prev ? prev.filter(farm => farm.id !== id) : []);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to delete farm');
      throw error;
    }
  }, [setLoading, setData, setError]);

  return { 
    ...state, 
    refetch: fetchFarms,
    createFarm,
    updateFarm,
    deleteFarm
  };
}

// Orders API hook
export function useOrders() {
  const { state, setLoading, setData, setError } = useApiState<any[]>();

  const fetchOrders = useCallback(async () => {
    setLoading(true);
    try {
      const data = await ordersAPI.getAll();
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch orders data');
    }
  }, [setLoading, setData, setError]);

  useEffect(() => {
    fetchOrders();
  }, [fetchOrders]);

  const createOrder = useCallback(async (orderData: any) => {
    setLoading(true);
    try {
      const newOrder = await ordersAPI.create(orderData);
      setData(prev => prev ? [...prev, newOrder] : [newOrder]);
      return newOrder;
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to create order');
      throw error;
    }
  }, [setLoading, setData, setError]);

  return { 
    ...state, 
    refetch: fetchOrders,
    createOrder
  };
}

// Authentication hook
export function useAuth() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const login = useCallback(async (email: string, password: string) => {
    setLoading(true);
    setError(null);
    try {
      const response = await authAPI.login({ email, password });
      // Store token in localStorage
      localStorage.setItem('access_token', response.access_token);
      setIsAuthenticated(true);
      return response;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Login failed';
      setError(errorMessage);
      throw error;
    } finally {
      setLoading(false);
    }
  }, []);

  const register = useCallback(async (userData: any) => {
    setLoading(true);
    setError(null);
    try {
      const response = await authAPI.register(userData);
      return response;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Registration failed';
      setError(errorMessage);
      throw error;
    } finally {
      setLoading(false);
    }
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem('access_token');
    setIsAuthenticated(false);
    setUser(null);
  }, []);

  // Check if user is authenticated on mount
  useEffect(() => {
    const token = localStorage.getItem('access_token');
    if (token) {
      setIsAuthenticated(true);
    }
  }, []);

  return {
    isAuthenticated,
    user,
    loading,
    error,
    login,
    register,
    logout,
  };
} 
 
 
import { 
  weatherAPI, 
  soilAPI, 
  cropsAPI, 
  marketAPI, 
  farmsAPI, 
  ordersAPI, 
  authAPI,
  type WeatherData,
  type SoilParameters,
  type CropData,
  type MarketData,
  type FarmData
} from '../services/api';

// Generic API state hook
interface ApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

function useApiState<T>() {
  const [state, setState] = useState<ApiState<T>>({
    data: null,
    loading: false,
    error: null,
  });

  const setLoading = useCallback((loading: boolean) => {
    setState(prev => ({ ...prev, loading, error: null }));
  }, []);

  const setData = useCallback((data: T) => {
    setState({ data, loading: false, error: null });
  }, []);

  const setError = useCallback((error: string) => {
    setState({ data: null, loading: false, error });
  }, []);

  return { state, setLoading, setData, setError };
}

// Weather API hook
export function useWeatherData(lat: number, lng: number) {
  const { state, setLoading, setData, setError } = useApiState<WeatherData>();

  const fetchWeather = useCallback(async () => {
    if (!lat || !lng) return;
    
    setLoading(true);
    try {
      const data = await weatherAPI.getForecast(lat, lng);
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch weather data');
    }
  }, [lat, lng, setLoading, setData, setError]);

  useEffect(() => {
    fetchWeather();
  }, [fetchWeather]);

  return { ...state, refetch: fetchWeather };
}

// Soil API hook
export function useSoilData(lat: number, lng: number) {
  const { state, setLoading, setData, setError } = useApiState<SoilParameters>();

  const fetchSoil = useCallback(async () => {
    if (!lat || !lng) return;
    
    setLoading(true);
    try {
      const data = await soilAPI.getData(lat, lng);
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch soil data');
    }
  }, [lat, lng, setLoading, setData, setError]);

  useEffect(() => {
    fetchSoil();
  }, [fetchSoil]);

  return { ...state, refetch: fetchSoil };
}

// Crops API hook
export function useCrops(page: number = 1, limit: number = 10, name?: string) {
  const { state, setLoading, setData, setError } = useApiState<{
    items: CropData[];
    total: number;
    page: number;
    pages: number;
  }>();

  const fetchCrops = useCallback(async () => {
    setLoading(true);
    try {
      const data = await cropsAPI.getAll(page, limit, name);
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch crops data');
    }
  }, [page, limit, name, setLoading, setData, setError]);

  useEffect(() => {
    fetchCrops();
  }, [fetchCrops]);

  return { ...state, refetch: fetchCrops };
}

// Market API hook
export function useMarketData() {
  const { state, setLoading, setData, setError } = useApiState<MarketData[]>();

  const fetchMarket = useCallback(async () => {
    setLoading(true);
    try {
      const data = await marketAPI.getData();
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch market data');
    }
  }, [setLoading, setData, setError]);

  useEffect(() => {
    fetchMarket();
  }, [fetchMarket]);

  return { ...state, refetch: fetchMarket };
}

// Farms API hook
export function useFarms() {
  const { state, setLoading, setData, setError } = useApiState<FarmData[]>();

  const fetchFarms = useCallback(async () => {
    setLoading(true);
    try {
      const data = await farmsAPI.getAll();
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch farms data');
    }
  }, [setLoading, setData, setError]);

  useEffect(() => {
    fetchFarms();
  }, [fetchFarms]);

  const createFarm = useCallback(async (farmData: Partial<FarmData>) => {
    setLoading(true);
    try {
      const newFarm = await farmsAPI.create(farmData);
      setData(prev => prev ? [...prev, newFarm] : [newFarm]);
      return newFarm;
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to create farm');
      throw error;
    }
  }, [setLoading, setData, setError]);

  const updateFarm = useCallback(async (id: string, farmData: Partial<FarmData>) => {
    setLoading(true);
    try {
      const updatedFarm = await farmsAPI.update(id, farmData);
      setData(prev => prev ? prev.map(farm => farm.id === id ? updatedFarm : farm) : [updatedFarm]);
      return updatedFarm;
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to update farm');
      throw error;
    }
  }, [setLoading, setData, setError]);

  const deleteFarm = useCallback(async (id: string) => {
    setLoading(true);
    try {
      await farmsAPI.delete(id);
      setData(prev => prev ? prev.filter(farm => farm.id !== id) : []);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to delete farm');
      throw error;
    }
  }, [setLoading, setData, setError]);

  return { 
    ...state, 
    refetch: fetchFarms,
    createFarm,
    updateFarm,
    deleteFarm
  };
}

// Orders API hook
export function useOrders() {
  const { state, setLoading, setData, setError } = useApiState<any[]>();

  const fetchOrders = useCallback(async () => {
    setLoading(true);
    try {
      const data = await ordersAPI.getAll();
      setData(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to fetch orders data');
    }
  }, [setLoading, setData, setError]);

  useEffect(() => {
    fetchOrders();
  }, [fetchOrders]);

  const createOrder = useCallback(async (orderData: any) => {
    setLoading(true);
    try {
      const newOrder = await ordersAPI.create(orderData);
      setData(prev => prev ? [...prev, newOrder] : [newOrder]);
      return newOrder;
    } catch (error) {
      setError(error instanceof Error ? error.message : 'Failed to create order');
      throw error;
    }
  }, [setLoading, setData, setError]);

  return { 
    ...state, 
    refetch: fetchOrders,
    createOrder
  };
}

// Authentication hook
export function useAuth() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const login = useCallback(async (email: string, password: string) => {
    setLoading(true);
    setError(null);
    try {
      const response = await authAPI.login({ email, password });
      // Store token in localStorage
      localStorage.setItem('access_token', response.access_token);
      setIsAuthenticated(true);
      return response;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Login failed';
      setError(errorMessage);
      throw error;
    } finally {
      setLoading(false);
    }
  }, []);

  const register = useCallback(async (userData: any) => {
    setLoading(true);
    setError(null);
    try {
      const response = await authAPI.register(userData);
      return response;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Registration failed';
      setError(errorMessage);
      throw error;
    } finally {
      setLoading(false);
    }
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem('access_token');
    setIsAuthenticated(false);
    setUser(null);
  }, []);

  // Check if user is authenticated on mount
  useEffect(() => {
    const token = localStorage.getItem('access_token');
    if (token) {
      setIsAuthenticated(true);
    }
  }, []);

  return {
    isAuthenticated,
    user,
    loading,
    error,
    login,
    register,
    logout,
  };
} 
 
 