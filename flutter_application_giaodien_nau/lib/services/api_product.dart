
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/product.dart'; // đúng theo tên file bạn đặt

 
// class ApiProduct {
//   static Future<List<Product>> fetchProducts() async {
//     final response = await http.get(Uri.parse('https://192.168.2.4:7286/api/SanPham'));

//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       return jsonData.map((item) => Product.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
// static Future<Product> fetchProductDetail(int id) async {
//   final response = await http.get(Uri.parse('https://192.168.2.4:7286/api/SanPham/$id'));
  
//   print('Response body: ${response.body}'); // debug thêm

//   if (response.statusCode == 200) {
//     final body = json.decode(response.body);
//     if (body == null || body is! Map<String, dynamic>) {
//       throw Exception("Dữ liệu trả về không hợp lệ");
//     }
//     return Product.fromJson(body);
//   } else {
//     throw Exception('Lỗi khi tải chi tiết sản phẩm');
//   }
// }


// }
import 'dart:convert';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiProduct {
  static const String _baseUrl = '${ApiConfig.baseUrl}/SanPham';

  /// Lấy danh sách sản phẩm
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải danh sách sản phẩm');
    }
  }

  /// Lấy chi tiết sản phẩm theo ID
 static Future<Product> fetchProductDetail(int id) async {
  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/SanPham/$id'));

  print('API response: ${response.body}');

  try {
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Product.fromJson(body);
    } else {
      throw Exception('Lỗi khi tải chi tiết sản phẩm');
    }
  } catch (e, stackTrace) {
    print('❌ Lỗi khi parse JSON: $e');
    print(stackTrace); // in dòng lỗi
    rethrow;
  }
}
static Future<List<Product>> searchProducts(String keyword) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/SanPham/search-detail?keyword=$keyword');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Không thể tìm kiếm sản phẩm');
  }
}
static Future<List<Product>> filterByNguoiDung({
  required int nguoiDungId,
  String? keyword,
  int? danhMucId,
  int? minPrice,
  int? maxPrice,
  bool? coGiamGia,
  String? sortBy,
}) async {
  final Map<String, String> queryParams = {
    'nguoiDungId': nguoiDungId.toString(),
    if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
    if (danhMucId != null) 'danhMucId': danhMucId.toString(),
    if (minPrice != null) 'minPrice': minPrice.toString(),
    if (maxPrice != null) 'maxPrice': maxPrice.toString(),
    if (coGiamGia != null) 'coGiamGia': coGiamGia.toString(),
    if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
  };

  final uri = Uri.parse('${ApiConfig.baseUrl}/SanPham/filter').replace(queryParameters: queryParams);

  final response = await http.get(uri);

  try {
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is! List) {
        throw Exception('Dữ liệu trả về không phải danh sách');
      }
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Không thể lọc sản phẩm: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print('❌ Lỗi khi lọc sản phẩm: $e');
    print(stackTrace);
    rethrow;
  }
}
}
