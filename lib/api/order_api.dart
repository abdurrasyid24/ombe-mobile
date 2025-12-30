import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';
import '../models/order_model.dart';

class OrderApi {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Get all orders for current user
  static Future<List<Order>> getOrders() async {
    try {
      final token = await _storage.read(key: _tokenKey);

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> ordersJson = jsonResponse['data'];
          return ordersJson.map((json) => Order.fromJson(json)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load orders');
        }
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting orders: $e');
    }
  }

  // Get single order by ID
  static Future<Order> getOrderById(String orderId) async {
    try {
      final token = await _storage.read(key: _tokenKey);

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return Order.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load order');
        }
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting order: $e');
    }
  }

  // Create new order
  static Future<Order> createOrder({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required Map<String, dynamic> deliveryAddress,
    String? notes,
    double? discount,
    String? couponCode,
    double? finalTotal,
  }) async {
    try {
      final token = await _storage.read(key: _tokenKey);

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final body = {
        'items': items,
        'paymentMethod': paymentMethod,
        'deliveryAddress': deliveryAddress,
        if (notes != null) 'notes': notes,
        if (discount != null) 'discount': discount,
        if (couponCode != null) 'couponCode': couponCode,
        if (finalTotal != null) 'finalTotal': finalTotal,
      };

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return Order.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to create order');
        }
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(
          errorResponse['message'] ??
              'Failed to create order: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  // Update order status (admin only)
  static Future<Order> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final token = await _storage.read(key: _tokenKey);

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final body = {'status': status};

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return Order.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to update order');
        }
      } else {
        throw Exception('Failed to update order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order: $e');
    }
  }

  // Cancel order
  static Future<void> cancelOrder(String orderId) async {
    try {
      final token = await _storage.read(key: _tokenKey);

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw Exception(jsonResponse['message'] ?? 'Failed to cancel order');
        }
      } else {
        throw Exception('Failed to cancel order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error canceling order: $e');
    }
  }
  // Get available payment methods
  static Future<List<Map<String, dynamic>>> getPaymentMethods({double amount = 10000}) async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.paymentMethods}?amount=$amount'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load payment methods');
        }
      } else {
        throw Exception('Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payment methods: $e');
    }
  }
}
