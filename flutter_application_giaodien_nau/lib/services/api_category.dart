import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';

import '../models/category.dart';
import '../models/product.dart';

class ApiCategory {
  // static const _baseUrl = 'https://192.168.2.4:7286/api';
  
    static const String _baseUrl = "${ApiConfig.baseUrl}";

  //  const String baseUrl = 'https://192.168.2.4:7286/api/Product';

  static HttpClient _getClient() {
    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }

  static Future<List<Category>> fetchCategories() async {
    try {
      final client = _getClient();
      final request = await client.getUrl(Uri.parse('$_baseUrl/Category'));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as List;
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  static Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    try {
      final client = _getClient();
      final request = await client.getUrl(Uri.parse('$_baseUrl/Product/GetByCategory/$categoryId'));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as List;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }
}
