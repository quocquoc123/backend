import 'dart:convert';

import 'package:flutter_application_giaodien_nau/models/thong_bao.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;

class ApiThongBao {
  static Future<List<ThongBao>> getThongBaoByNguoiDung(int nguoiDungId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/ThongBao/nguoidung/$nguoiDungId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ThongBao.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi tải thông báo');
    }
  }
}
