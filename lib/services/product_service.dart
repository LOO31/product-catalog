import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> productsJson = data['products'];

      return productsJson
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?q=${Uri.encodeComponent(query)}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> productsJson = data['products'];

      return productsJson
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}