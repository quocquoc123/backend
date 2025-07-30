import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiAuth {
  // static const String _baseUrl = "https://192.168.2.4:7286/api/NguoiDung";
  static const String _baseUrl = "${ApiConfig.baseUrl}/NguoiDung";

  // ======== ĐĂNG NHẬP BẰNG EMAIL ========
static Future<Map<String, dynamic>?> login({
  required String email,
  required String matKhau,
}) async {
  final url = Uri.parse("$_baseUrl/dangnhap");
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "matKhau": matKhau,
      }),
    );

    print("📨 Status code: ${response.statusCode}");
    print("📄 Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("📦 JSON decode: $data");

      final prefs = await SharedPreferences.getInstance();

      /// 👇 Lấy id trực tiếp vì nó nằm ở cấp root
      final id = data['id'];
      if (id != null) {
        await prefs.setInt('userId', id);
        print('✅ Đã lưu userId vào SharedPreferences: $id');
      } else {
        print('⚠️ Không tìm thấy id trong response!');
      }

      return data;
    } else {
      return null;
    }
  } catch (e) {
    print("❌ Exception khi đăng nhập: $e");
    return null;
  }
}

  // ======== ĐĂNG KÝ ========
static Future<bool> register({
  required String tenDangNhap,
  required String matKhau,
  required String hoTen,
  required String email,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/dangky'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "tenDangNhap": tenDangNhap,
        "matKhau": matKhau,
        "hoTen": hoTen,
        "email": email,
      }),
    );

    print('📩 Phản hồi đăng ký: ${response.statusCode}');
    print('📄 Body: ${response.body}');

   if (response.statusCode == 200) {
  final data = jsonDecode(response.body);

  final prefs = await SharedPreferences.getInstance();

  // 👇 Tìm id trong object cha hoặc object con 'user'
  final id = data['id'] ?? data['user']?['id'];
  if (id != null) {
    await prefs.setInt('userId', id);
    print('✅ Đã lưu userId: $id');
  } else {
    print('⚠️ Không tìm thấy id trong response!');
  }

  return data;
}
 else {
      return false;
    }
  } catch (e) {
    print("❌ Lỗi đăng ký: $e");
    return false;
  }
}


  // ======== GỬI OTP QUA EMAIL (quên mật khẩu) ========
  static Future<bool> sendOTP(String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/quen-mat-khau"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200;
  }

  // ======== XÁC NHẬN OTP ========
  static Future<bool> verifyOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/xac-thuc-otp-email"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    return response.statusCode == 200;
  }

  // ======== ĐẶT LẠI MẬT KHẨU ========
  static Future<bool> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/dat-lai-mat-khau-email"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'matKhauMoi': newPassword,
      }),
    );
    return response.statusCode == 200;
  }
 // XÁC THỰC ĐĂNG NHẬP SAU KHI NHẬP OTP
static Future<Map<String, dynamic>?> verifyLoginOTP({
  required String email,
  required String selectedOtp,
}) async {
  final response = await http.post(
    Uri.parse("$_baseUrl/xac-thuc-dang-nhap"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'selectedOtp': selectedOtp,
    }),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}
  // ======== (TUỲ CHỌN) LẤY HỒ SƠ THEO ID ========
  /// Nếu sau này cần thêm SĐT, ảnh,… thì gọi hàm này
 static Future<Map<String, dynamic>?> getUserById({
  required int id,
  required String token,
}) async {
  try {
    final res = await http.get(
      Uri.parse("$_baseUrl/nguoi-dung/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('getUserById lỗi: status code ${res.statusCode}, body: ${res.body}');
      return null;
    }
  } catch (e) {
    print('Exception trong getUserById: $e');
    return null;
  }
}

  // ======== CẬP NHẬT HỒ SƠ NGƯỜI DÙNG ========
 /// Cập nhật hồ sơ (public, xác minh bằng mật khẩu cũ)
static Future<bool> updateProfilePublic({
  required String email,
  required String matKhauCu,
  required String hoTen,
  required String soDienThoai,
}) async {
  final res = await http.put(
    Uri.parse("$_baseUrl/cap-nhat-thong-tin-public"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email"       : email.trim(),
      "matKhauCu"   : matKhauCu,
      "hoTen"       : hoTen.trim(),
      "soDienThoai" : soDienThoai.trim(),
    }),
  );

  print('🔵 status   = ${res.statusCode}');
  print('🔵 body     = ${res.body}');
  return res.statusCode == 200;
}
// ĐỔI MẬT KHẨU
static Future<bool> changePasswordPublic({
  required String email,
  required String matKhauCu,
  required String matKhauMoi,
}) async {
  final res = await http.put(
    Uri.parse("$_baseUrl/doi-mat-khau-public"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email.trim(),
      "matKhauCu": matKhauCu,
      "matKhauMoi": matKhauMoi,
    }),
  );

  print('🔑 changePw status = ${res.statusCode}');
  print('🔑 body     = ${res.body}');
  return res.statusCode == 200;
}

static Future<Map<String, dynamic>?> uploadAvatar(XFile pickedFile, String email) async {
  final Uri base = Uri.parse(_baseUrl); // Ex: https://localhost:7000
  final origin = '${base.scheme}://${base.host}:${base.port}';
  final uri = Uri.parse('$origin/api/NguoiDung/upload-avatar');
  debugPrint('📤 Upload → $uri');

  final req = http.MultipartRequest('POST', uri)
    ..fields['email'] = email;

  try {
    // ✅ Thêm ảnh vào request
    if (kIsWeb) {
      req.files.add(http.MultipartFile.fromBytes(
        'file', await pickedFile.readAsBytes(),
        filename: pickedFile.name,
        contentType: MediaType('image', 'jpeg'),
      ));
    } else {
      req.files.add(await http.MultipartFile.fromPath(
        'file', pickedFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    // ✅ Gửi request
    final res = await req.send();
    final body = await res.stream.bytesToString();
    debugPrint('📨 Status: ${res.statusCode}');
    debugPrint('📨 Body  : $body');

    if (res.statusCode != 200) return null;

    final json = jsonDecode(body);
    final user = json['user'];  // 👈 lấy user object
    if (user == null) return null;

    // 🔄 Thêm timestamp để tránh cache avatar
    if (user['anhDaiDien'] != null && user['anhDaiDien'] is String) {
      user['anhDaiDien'] += '?ts=${DateTime.now().millisecondsSinceEpoch}';
    }

    return Map<String, dynamic>.from(user); // ✅ Trả về user đã cập nhật
  } catch (e) {
    debugPrint('❌ Upload error: $e');
    return null;
  }
}



// ======== ĐĂNG XUẤT ========
static Future<bool> logout() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userData');
    return true;
  } catch (e) {
    print('Logout exception: $e');
    return false;
  }
}



}
