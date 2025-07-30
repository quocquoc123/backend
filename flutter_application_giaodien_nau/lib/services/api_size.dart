import 'dart:convert';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/size.dart';

class ApiSize {
  static Future<List<SizeModel>> getSizes() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}//Size'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => SizeModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải size');
    }
  }
  static Future<List<SizeModel>> fetchSizes(int productId) async {
  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}//ChiTietSanPham/GetSizesByProduct/$productId'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);

    // Bỏ các phần tử null nếu có
    return jsonData
        .where((e) => e != null)
        .map((e) => SizeModel.fromJson(e))
        .toList();
  } else {
    throw Exception('Không lấy được size theo sản phẩm');
  }
}

}
