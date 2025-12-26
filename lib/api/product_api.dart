import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_api_model.dart';
import 'api_config.dart';

class ProductApiService {
  // Get all products with optional filters
  static Future<List<ProductApi>> getProducts({
    String? category,
    bool? featured,
    String? search,
    String? sort,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (featured != null) queryParams['featured'] = featured.toString();
      if (search != null) queryParams['search'] = search;
      if (sort != null) queryParams['sort'] = sort;
      
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['data'];
        return productsJson.map((json) => ProductApi.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Get single product by ID
  static Future<ProductApi> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productById(id)}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProductApi.fromJson(data['data']);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Get featured products
  static Future<List<ProductApi>> getFeaturedProducts() async {
    return getProducts(featured: true);
  }

  // Get products by category
  static Future<List<ProductApi>> getProductsByCategory(String category) async {
    return getProducts(category: category);
  }
}
