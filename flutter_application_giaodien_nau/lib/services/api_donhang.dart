import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_giaodien_nau/models/checkoutreorder.dart';
import 'package:flutter_application_giaodien_nau/models/donhang.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/checkout_request.dart';

class ApiDonHang {
  // static const String baseUrl = 'https://192.168.2.4:7286/api/DonHang';
    static const String _baseUrl = "${ApiConfig.baseUrl}/DonHang";


  static Future<bool> checkout(CheckoutRequest request) async {
    final url = Uri.parse('$_baseUrl/checkout');
    final client = HttpClient();

    try {
      final req = await client.postUrl(url);
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode(request.toJson()));

      final res = await req.close();

      if (res.statusCode == 200) {
        return true;
      } else {
        print("Checkout failed with status: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print("Checkout error: $e");
      return false;
    } finally {
      client.close();
    }
  }

  static Future<List<DonHangDTO>> getLichSuDonHang(int userId) async {
  final url = Uri.parse('$_baseUrl/user/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => DonHangDTO.fromJson(e)).toList();
    } else {
      print("❌ API lỗi: ${response.statusCode} - ${response.body}");
      throw Exception("Lỗi lấy danh sách đơn hàng");
    }
  } catch (e) {
    print("❌ Exception khi gọi API: $e");
    rethrow;
  }

  
}
static Future<List<DonHangDTO>> getDonHangTheoChiNhanh(int chiNhanhId) async {
  final url = Uri.parse('$_baseUrl/ByChiNhanh/$chiNhanhId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => DonHangDTO.fromJson(e)).toList();
    } else {
      print("❌ Lỗi khi lấy đơn hàng theo chi nhánh: ${response.statusCode}");
      throw Exception('Lỗi API');
    }
  } catch (e) {
    print("❌ Exception: $e");
    rethrow;
  }
}

static Future<void> updateTrangThaiDonHang(int donHangId, String trangThaiMoi) async {
  final response = await http.put(
    Uri.parse('${ApiConfig.baseUrl}/DonHang/UpdateTrangThai/$donHangId'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'TrangThaiMoi': trangThaiMoi, // ✅ Phù hợp với CapNhatTrangThaiDTO
    }),
  );

  if (response.statusCode == 200) {
    print('✅ Cập nhật trạng thái thành công');
  } else {
    print('❌ Lỗi cập nhật trạng thái: ${response.body}');
  }
}





}
