import 'dart:convert';

import 'package:flutter_application_giaodien_nau/models/chinhanh.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;

Future<List<ChiNhanh>> fetchChiNhanhs() async {
  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/ChiNhanhs'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => ChiNhanh.fromJson(e)).toList();
  } else {
    throw Exception('❌ Không thể tải danh sách chi nhánh');
  }
}


class ApiChiNhanh {
  static const String _baseUrl = "${ApiConfig.baseUrl}/ChiNhanhs";

  static Future<List<ChiNhanh>> getAllChiNhanhs() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ChiNhanh.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi lấy danh sách chi nhánh");
    }
  }
  
}
