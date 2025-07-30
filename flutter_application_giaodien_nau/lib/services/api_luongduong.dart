import 'dart:convert';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/luongduong.dart';

class ApiLuongDuong {
  static Future<List<LuongDuong>> getAll() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}//LuongDuong'));

    
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => LuongDuong.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải lượng đường');
    }
  }
  static Future<List<LuongDuong>> fetchLuongDuong(int productId) async {
  final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}//ChiTietSanPham/GetDuongByProduct/$productId'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);

    // ⚠️ Lọc bỏ các phần tử null trước khi parse
    return jsonData
        .where((e) => e != null)
        .map((e) => LuongDuong.fromJson(e))
        .toList();
  } else {
    throw Exception('Không lấy được lượng đường theo sản phẩm');
  }
}

}
