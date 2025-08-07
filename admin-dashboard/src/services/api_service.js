const API_BASE_URL = 'http://localhost:8000/api/v1';

class ApiService {
  constructor() {
    this.baseURL = API_BASE_URL;
  }

  // Get auth headers
  getHeaders() {
    const token = localStorage.getItem('token');
    return {
      'Content-Type': 'application/json',
      ...(token && { 'Authorization': `Bearer ${token}` })
    };
  }

  // Generic request method
  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    const config = {
      headers: this.getHeaders(),
      ...options
    };

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        if (response.status === 401) {
          // Handle unauthorized - redirect to login
          localStorage.removeItem('token');
          window.location.href = '/login';
          return;
        }
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // User management endpoints
  async getUsers(role = null, page = 1, limit = 10) {
    const params = new URLSearchParams();
    if (role) params.append('role', role);
    params.append('page', page);
    params.append('limit', limit);
    
    return this.request(`/users/admin/all?${params.toString()}`);
  }

  async getUsersByRole(role) {
    return this.request(`/users/admin/by-role/${role}`);
  }

  async getUserStatistics() {
    return this.request('/users/admin/statistics');
  }

  async getUserRoles() {
    return this.request('/users/admin/roles');
  }

  // Farm management endpoints
  async getFarms() {
    return this.request('/farms');
  }

  async getFarmById(farmId) {
    return this.request(`/farms/${farmId}`);
  }

  // Marketplace endpoints
  async getProducts(page = 1, limit = 10) {
    const params = new URLSearchParams();
    params.append('page', page);
    params.append('limit', limit);
    
    return this.request(`/marketplace/products?${params.toString()}`);
  }

  async getOrders(page = 1, limit = 10) {
    const params = new URLSearchParams();
    params.append('page', page);
    params.append('limit', limit);
    
    return this.request(`/orders?${params.toString()}`);
  }

  // Messages/SMS endpoints
  async sendBulkSMS(recipients, message) {
    return this.request('/messages/bulk', {
      method: 'POST',
      body: JSON.stringify({
        recipients,
        message,
        type: 'sms'
      })
    });
  }

  // Authentication
  async login(email, password) {
    const formData = new FormData();
    formData.append('username', email);
    formData.append('password', password);

    const response = await fetch(`${this.baseURL}/auth/login`, {
      method: 'POST',
      body: formData
    });

    if (!response.ok) {
      throw new Error('Login failed');
    }

    const data = await response.json();
    localStorage.setItem('token', data.access_token);
    return data;
  }

  async logout() {
    localStorage.removeItem('token');
  }

  // Check if user is authenticated
  isAuthenticated() {
    return !!localStorage.getItem('token');
  }

  // Get current user info
  async getCurrentUser() {
    return this.request('/users/me');
  }
}

// Create singleton instance
const apiService = new ApiService();

export default apiService; 