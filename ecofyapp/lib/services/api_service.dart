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
      'email': email,
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

  static Future<void> logout() async {
    await clearAuthToken();
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

  // Farms endpoints
  static Future<List<Map<String, dynamic>>> getFarms() async {
    final response = await _makeRequest('/farms', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch farms: ${response.body}');
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

  // Orders endpoints
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await _makeRequest('/orders', 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch orders: ${response.body}');
    }
  }

  // External endpoints (weather, soil data)
  static Future<Map<String, dynamic>> getWeatherData(double lat, double lng) async {
    final response = await _makeRequest('/weather?lat=$lat&lng=$lng', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getSoilData(double lat, double lng) async {
    final response = await _makeRequest('/soil-data?lat=$lat&lng=$lng', 'GET');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch soil data: ${response.body}');
    }
  }
} 