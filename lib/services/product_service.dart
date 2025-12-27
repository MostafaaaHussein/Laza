import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String apiUrl = 'https://api.escuelajs.co/api/v1/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to fetch products. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final products = await fetchProducts();
    if (query.isEmpty) return products;
    
    return products.where((product) {
      final titleLower = product.title.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();
  }
}
