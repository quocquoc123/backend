import 'dart:convert';
import 'package:flutter_application_giaodien_nau/models/SanPhamChiTiet%20.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/size.dart';
import '../models/topping.dart';
import '../models/luongduong.dart';

class ApiChiTietSanPham {
  // static const String _baseUrl = 'https://192.168.2.4:7286/api';
    static const String _baseUrl = "${ApiConfig.baseUrl}";



 static Future<List<SanPhamChiTiet>> getChiTietSanPhamByProduct(int sanPhamId) async {
final response = await http.get(Uri.parse('$_baseUrl/ChiTietSanPham/BySanPham/$sanPhamId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => SanPhamChiTiet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load product detail list');
    }
  }
  // Lấy danh sách size
  static Future<List<SizeModel>> getSizes() async {
    final response = await http.get(Uri.parse('$_baseUrl/Size'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SizeModel.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải size');
    }
  }

  // Lấy danh sách lượng đường
  static Future<List<LuongDuong>> getDuong() async {
    final response = await http.get(Uri.parse('$_baseUrl/LuongDuong'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => LuongDuong.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải lượng đường');
    }
  }

  // Lấy danh sách topping
  static Future<List<Topping>> getToppings() async {
    final response = await http.get(Uri.parse('$_baseUrl/Topping'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Topping.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải topping');
    }
  }

  // Tạo chi tiết sản phẩm (sau khi người dùng chọn size, đường, topping)
  static Future<Map<String, dynamic>?> createChiTietSanPham(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ChiTietSanPham/TaoChiTiet'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Lỗi tạo chi tiết sản phẩm: ${response.body}');
      return null;
    }
  }
  static Future<bool> updateChiTietSanPham(int id, Map<String, dynamic> data) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/ChiTietSanPham/$id');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  return response.statusCode == 200;
}

}
