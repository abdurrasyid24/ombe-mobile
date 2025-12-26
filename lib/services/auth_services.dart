import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_config.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>?;
        
        if (data != null) {
          // Extract token and user from response
          final token = data['token'] as String?;
          final user = data['user'] as Map<String, dynamic>?;

          if (token != null && user != null) {
            await _storage.write(key: _tokenKey, value: token);
            await _storage.write(key: _userKey, value: jsonEncode(user));
          }
        }
      }

      return json;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
    String? address,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 201 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>?;
        
        if (data != null) {
          // Extract token and user from response
          final token = data['token'] as String?;
          final user = data['user'] as Map<String, dynamic>? ?? data;

          if (token != null) {
            await _storage.write(key: _tokenKey, value: token);
            await _storage.write(key: _userKey, value: jsonEncode(user));
          }
        }
      }

      return json;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      final token = await getToken();
      
      if (token != null) {
        final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        await http.post(url, headers: headers);
      }

      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      return true;
    } catch (e) {
      // Even if request fails, clear local storage
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      return false;
    }
  }

  /// Get current user profile from backend
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.me}');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          final data = json['data'] as Map<String, dynamic>?;
          if (data != null) {
            await _storage.write(key: _userKey, value: jsonEncode(data));
          }
          return data;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  /// Check if user is admin
  Future<bool> isAdmin() async {
    final user = await getUser();
    return user?['role'] == 'admin';
  }
}
