import 'dart:convert';
import 'package:flutter_application_giaodien_nau/models/bantin.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;


class BanTinApi {
  static const String baseUrl = "${ApiConfig.baseUrl}/BanTin"; // đổi port phù hợp

  static Future<List<BanTin>> fetchBanTins() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => BanTin.fromJson(item)).toList();
    } else {
      throw Exception('Lỗi khi tải bản tin');
    }
  }

  static Future<BanTin> fetchBanTinById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return BanTin.fromJson(json.decode(response.body));
    } else {
      throw Exception('Không tìm thấy bản tin');
    }
  }

  static Future<void> createBanTin(BanTin banTin) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(banTin.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Thêm bản tin thất bại');
    }
  }

  static Future<void> updateBanTin(BanTin banTin) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${banTin.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(banTin.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Cập nhật bản tin thất bại');
    }
  }

  static Future<void> deleteBanTin(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Xóa bản tin thất bại');
    }
  }
}
