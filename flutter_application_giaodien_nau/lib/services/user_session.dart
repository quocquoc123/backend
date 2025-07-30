import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // thêm các getter/setter cho hoTen, email, vaiTro nếu cần
}
