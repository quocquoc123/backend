import 'dart:convert';
import 'package:flutter_application_giaodien_nau/models/CartItem.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
class ApiGioHang {
  // static const String baseUrl = 'https://192.168.2.4:7286/api/GioHang';
  
    static const String baseUrl = "${ApiConfig.baseUrl}/GioHang";

  static Future<List<CartItem>> getCartByUser(int nguoiDungId) async {
    final response = await http.get(Uri.parse('$baseUrl/ByNguoiDung/$nguoiDungId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => CartItem.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi tải giỏ hàng');
    }
  }

  static Future<bool> addToCart(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/AddToCart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
  static Future<bool> updateSoLuong(int gioHangId, int newSoLuong) async {
  final response = await http.put(
    Uri.parse('$baseUrl/UpdateSoLuong/$gioHangId'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(newSoLuong),
  );
  return response.statusCode == 200;
}
static Future<bool> deleteCartItem(int cartItemId) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/Delete/$cartItemId'),
  );
  return response.statusCode == 200;
}


}
