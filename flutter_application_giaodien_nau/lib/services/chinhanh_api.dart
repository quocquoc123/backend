import 'dart:convert';
import 'package:flutter_application_giaodien_nau/models/chinhanhmap.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;


class ChiNhanhApi {
  static const String _baseUrl = "${ApiConfig.baseUrl}/ChiNhanhMap";

  /// ✅ Hàm này dùng để debug chính xác baseUrl đang dùng
  static void debugBaseUrl() {
    print("🔎 BASE URL ĐANG DÙNG: $_baseUrl");
  }

  static Future<List<ChiNhanh>> fetchChiNhanhs() async {
    debugBaseUrl(); // Gọi hàm debug base URL

    try {
      print("🔍 Đang gọi API tới: $_baseUrl");

      final response = await http.get(Uri.parse(_baseUrl));

      print("📥 Trạng thái HTTP: ${response.statusCode}");
      print("📦 Dữ liệu trả về (raw): ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          print("✅ JSON parse thành công, số lượng: ${decoded.length}");
        } else {
          print("❌ JSON không phải List, kiểu là: ${decoded.runtimeType}");
        }

        final List<dynamic> data = decoded;
        final chiNhanhs = data.map((json) {
          print("🔄 Đang parse chi nhánh: $json");
          return ChiNhanh.fromJson(json);
        }).toList();

        for (var cn in chiNhanhs) {
          print("📍 Chi nhánh: ${cn.name}, Lat: ${cn.latitude}, Lng: ${cn.longitude}");
        }

        return chiNhanhs;
      } else {
        print("❌ Lỗi HTTP: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception('Lỗi khi tải danh sách chi nhánh: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ LỖI GỌI API: $e');
      print('🧱 StackTrace: $stackTrace');
      throw Exception('Lỗi khi gọi API chi nhánh: $e');
    }
  }
}
