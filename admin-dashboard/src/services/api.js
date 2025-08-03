import axios from 'axios';
import toast from 'react-hot-toast';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';

// Create axios instance
const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('adminToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - redirect to login
      localStorage.removeItem('adminToken');
      window.location.href = '/login';
    } else if (error.response?.status >= 500) {
      toast.error('Server error. Please try again later.');
    } else if (error.response?.data?.detail) {
      toast.error(error.response.data.detail);
    } else if (error.message) {
      toast.error(error.message);
    }
    return Promise.reject(error);
  }
);

export const apiService = {
  // Generic HTTP methods
  async get(url, config = {}) {
    const response = await api.get(url, config);
    return response.data;
  },

  async post(url, data, config = {}) {
    const response = await api.post(url, data, config);
    return response.data;
  },

  async put(url, data, config = {}) {
    const response = await api.put(url, data, config);
    return response.data;
  },

  async delete(url, config = {}) {
    const response = await api.delete(url, config);
    return response.data;
  },

  // Admin Dashboard APIs
  async getDashboard() {
    return this.get('/admin/analytics/dashboard');
  },

  // Training Data APIs
  async getTrainingData(params = {}) {
    const queryString = new URLSearchParams(params).toString();
    return this.get(`/admin/training-data?${queryString}`);
  },

  async addTrainingData(data) {
    const formData = new FormData();
    Object.keys(data).forEach(key => {
      if (data[key] !== null && data[key] !== undefined) {
        formData.append(key, data[key]);
      }
    });
    return this.post('/admin/training-data/add', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  async bulkAddTrainingData(dataList) {
    return this.post('/admin/training-data/bulk-add', dataList);
  },

  async uploadExcelData(file, cropType, region) {
    const formData = new FormData();
    formData.append('file', file);
    if (cropType) formData.append('crop_type', cropType);
    if (region) formData.append('region', region);
    
    return this.post('/admin/training-data/upload-excel', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  // Model Training APIs
  async startTraining(jobName, baseModel = 'gpt-4o-mini', includeExcelData = true) {
    return this.post('/admin/training/start', {
      job_name: jobName,
      base_model: baseModel,
      include_excel_data: includeExcelData,
    });
  },

  async getTrainingStatus(jobId) {
    return this.get(`/admin/training/status/${jobId}`);
  },

  async deployModel(jobId) {
    return this.post(`/admin/training/deploy/${jobId}`);
  },

  // Voice Training APIs
  async getVoiceStats() {
    return this.get('/admin/voice-training/stats');
  },

  async getVoiceAnalytics() {
    return this.get('/admin/analytics/voice-training');
  },

  async addManualVoiceSample(audioFile, transcription, region = 'Tanzania') {
    const formData = new FormData();
    formData.append('audio_file', audioFile);
    formData.append('transcription', transcription);
    formData.append('region', region);
    
    return this.post('/admin/voice-training/manual-sample', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  // WhatsApp APIs
  async getWhatsAppTemplates(params = {}) {
    const queryString = new URLSearchParams(params).toString();
    return this.get(`/whatsapp/templates?${queryString}`);
  },

  async sendTemplateMessage(templateData) {
    return this.post('/whatsapp/templates/send', templateData);
  },

  async getWhatsAppSessions() {
    return this.get('/whatsapp/sessions');
  },

  async getWhatsAppMessages() {
    return this.get('/whatsapp/messages');
  },

  async sendFarmingAlert(phoneNumber, message, templateId = null) {
    return this.post('/whatsapp/alerts/send', {
      phone_number: phoneNumber,
      alert_message: message,
      template_id: templateId,
    });
  },

  async testAIChat(message) {
    return this.get(`/whatsapp/test/ai?message=${encodeURIComponent(message)}`);
  },

  // User Feedback APIs
  async getUserFeedback(params = {}) {
    const queryString = new URLSearchParams(params).toString();
    return this.get(`/admin/feedback?${queryString}`);
  },

  // File Upload Helper
  async uploadFile(file, endpoint, additionalData = {}) {
    const formData = new FormData();
    formData.append('file', file);
    
    Object.keys(additionalData).forEach(key => {
      formData.append(key, additionalData[key]);
    });

    return this.post(endpoint, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  // WebSocket connection for real-time updates
  connectWebSocket(onMessage) {
    const wsUrl = API_BASE_URL.replace('http', 'ws') + '/ws/admin';
    const ws = new WebSocket(wsUrl);
    
    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      onMessage(data);
    };

    ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    return ws;
  },
};

export default apiService; 