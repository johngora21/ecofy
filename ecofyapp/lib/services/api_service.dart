import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String tokenKey = 'auth_token';

  // Get stored auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Store auth token
  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Clear auth token
  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Generic HTTP request with auth
  static Future<http.Response> _makeRequest(
    String endpoint,
    String method, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final token = await getAuthToken();
    final url = Uri.parse('$baseUrl$endpoint');
    
    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: requestHeaders);
      case 'POST':
        return await http.post(
          url,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          url,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(url, headers: requestHeaders);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _makeRequest('/auth/login', 'POST', body: {
      'username': email, // API expects 'username' for email
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setAuthToken(data['access_token']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await _makeRequest('/auth/register', 'POST', body: userData);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  static Future<void> logout() async {
    try {
      await _makeRequest('/auth/logout', 'POST');
    } finally {
      await clearAuthToken();
    }
  }

  // User endpoints
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _makeRequest('/users/me', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user profile: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
    final response = await _makeRequest('/users/me', 'PUT', body: userData);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user profile: ${response.body}');
    }
  }

  // Market endpoints
  static Future<Map<String, dynamic>> getMarketPrices({String? cropId, String? date}) async {
    final queryParams = <String, String>{};
    if (cropId != null) queryParams['crop_id'] = cropId;
    if (date != null) queryParams['date'] = date;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/market/prices?$queryString', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch market prices: ${response.body}');
    }
  }

  // Real-time market data endpoints
  static Future<Map<String, dynamic>> getRealTimePrices() async {
    final response = await _makeRequest('/market/prices/latest', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch real-time prices: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getCropSupplyPrices({int limit = 100}) async {
    final response = await _makeRequest('/market/cropsupply/prices?limit=$limit', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch CropSupply prices: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getScrapedMarketData({String? source, int limit = 100}) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
    };
    if (source != null) queryParams['source'] = source;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/market/prices/scraped?$queryString', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch scraped market data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getAITrainingData({String? source, double minQuality = 0.5, int limit = 100}) async {
    final queryParams = <String, String>{
      'min_quality': minQuality.toString(),
      'limit': limit.toString(),
    };
    if (source != null) queryParams['source'] = source;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/market/ai/training-data?$queryString', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch AI training data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getScrapingStatus() async {
    final response = await _makeRequest('/market/scrape/status', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch scraping status: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> triggerHistoricalScraping() async {
    final response = await _makeRequest('/market/scrape/historical', 'POST');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to trigger historical scraping: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> triggerCropSupplyScraping() async {
    final response = await _makeRequest('/market/scrape/cropsupply', 'POST');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to trigger CropSupply scraping: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getLatestPrices() async {
    final response = await _makeRequest('/market/prices/latest', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch latest prices: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getPriceHistory({String? cropName, int days = 30}) async {
    final queryParams = <String, String>{
      'days': days.toString(),
    };
    if (cropName != null) queryParams['crop_name'] = cropName;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/market/prices/history?$queryString', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch price history: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getPriceSources() async {
    final response = await _makeRequest('/market/prices/sources', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch price sources: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getMarketTrends(String cropId, {String period = 'month'}) async {
    final response = await _makeRequest('/market/trends?crop_id=$cropId&period=$period', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch market trends: ${response.body}');
    }
  }

  // Crops endpoints
  static Future<List<Map<String, dynamic>>> getCrops() async {
    final response = await _makeRequest('/crops', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch crops: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getCrop(String cropId) async {
    final response = await _makeRequest('/crops/$cropId', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch crop: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getCropMarketData(String cropId) async {
    final response = await _makeRequest('/crops/$cropId/market-data', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch crop market data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getCropRecommendations(String cropId, {String? farmId}) async {
    final queryParams = <String, String>{};
    if (farmId != null) queryParams['farm_id'] = farmId;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/crops/$cropId/recommendations?$queryString', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch crop recommendations: ${response.body}');
    }
  }

  // Marketplace endpoints
  static Future<Map<String, dynamic>> getProducts({
    String? category,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/marketplace/products?$queryString', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch products: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getProduct(String productId) async {
    final response = await _makeRequest('/marketplace/products/$productId', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch product: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    final response = await _makeRequest('/marketplace/products', 'POST', body: productData);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  // Farms endpoints
  static Future<List<Map<String, dynamic>>> getFarms() async {
    // For farms, we don't need authentication since the backend endpoint is unauthenticated
    final url = Uri.parse('$baseUrl/farms');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch farms: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getFarm(String farmId) async {
    final response = await _makeRequest('/farms/$farmId', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch farm: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createFarm(Map<String, dynamic> farmData) async {
    final response = await _makeRequest('/farms', 'POST', body: farmData);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create farm: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateFarm(String farmId, Map<String, dynamic> farmData) async {
    final response = await _makeRequest('/farms/$farmId', 'PUT', body: farmData);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update farm: ${response.body}');
    }
  }

  static Future<void> deleteFarm(String farmId) async {
    final response = await _makeRequest('/farms/$farmId', 'DELETE');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete farm: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> addCropHistory(String farmId, Map<String, dynamic> cropHistory) async {
    final response = await _makeRequest('/farms/$farmId/crop-history', 'POST', body: cropHistory);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add crop history: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateFarmSoilData(String farmId) async {
    final response = await _makeRequest('/farms/$farmId/update-soil', 'PUT');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update farm soil data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateFarmBoundary(String farmId, List<Map<String, double>> boundary) async {
    final response = await _makeRequest('/farms/$farmId/boundary', 'POST', body: {
      'boundary': boundary,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update farm boundary: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getFarmBoundary(String farmId) async {
    final response = await _makeRequest('/farms/$farmId/boundary', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch farm boundary: ${response.body}');
    }
  }

  // Orders endpoints
  static Future<List<Map<String, dynamic>>> getOrders({String? type, String? status}) async {
    final queryParams = <String, String>{};
    if (type != null) queryParams['type'] = type;
    if (status != null) queryParams['status'] = status;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await _makeRequest('/orders?$queryString', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch orders: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getOrder(String orderId) async {
    final response = await _makeRequest('/orders/$orderId', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch order: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final response = await _makeRequest('/orders', 'POST', body: orderData);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  // Notifications endpoints
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await _makeRequest('/notifications', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch notifications: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    final response = await _makeRequest('/notifications/$notificationId/read', 'PATCH');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to mark notification as read: ${response.body}');
    }
  }

  // Chat endpoints
  static Future<List<Map<String, dynamic>>> getChatConversations() async {
    final response = await _makeRequest('/chat/conversations', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch chat conversations: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getChatMessages(String conversationId) async {
    final response = await _makeRequest('/chat/messages/$conversationId', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch chat messages: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> sendChatMessage(Map<String, dynamic> messageData) async {
    final response = await _makeRequest('/chat/messages', 'POST', body: messageData);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send chat message: ${response.body}');
    }
  }

  // External endpoints (weather, soil data)
  static Future<Map<String, dynamic>> getWeatherData(double lat, double lng) async {
    final response = await _makeRequest('/weather/forecast?lat=$lat&lng=$lng', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getSoilData(double lat, double lng) async {
    final response = await _makeRequest('/satellite/soil?lat=$lat&lng=$lng', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch soil data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getSoilDataForFarm(double lat, double lng) async {
    final response = await _makeRequest('/farms/soil-data?lat=$lat&lng=$lng', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch soil data for farm: ${response.body}');
    }
  }

  // Comprehensive farm creation with all data
  static Future<Map<String, dynamic>> createFarmWithAnalysis({
    required String name,
    required String location,
    required String size,
    String? description,
    required double latitude,
    required double longitude,
    List<Map<String, double>>? farmBoundary,
    Map<String, dynamic>? soilAnalysis,
    Map<String, dynamic>? climateData,
    Map<String, dynamic>? topographyData,
    List<String>? selectedCrops,
  }) async {
    final farmData = {
      'name': name,
      'location': location,
      'size': size,
      'description': description,
      'coordinates': {
        'lat': latitude.toString(),
        'lng': longitude.toString(),
      },
      if (farmBoundary != null) 'farm_boundary': farmBoundary,
      if (soilAnalysis != null) 'soil_analysis': soilAnalysis,
      if (climateData != null) 'climate_data': climateData,
      if (topographyData != null) 'topography_data': topographyData,
      if (selectedCrops != null) 'selected_crops': selectedCrops,
    };

    final response = await _makeRequest('/farms', 'POST', body: farmData);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create farm: ${response.body}');
    }
  }

  // Analyze soil for existing farm
  static Future<Map<String, dynamic>> analyzeFarmSoil(String farmId) async {
    final response = await _makeRequest('/farms/$farmId/analyze-soil', 'POST');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze farm soil: ${response.body}');
    }
  }
}