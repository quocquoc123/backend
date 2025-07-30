import 'dart:convert';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/topping.dart';

class ApiTopping {
  static Future<List<Topping>> getToppings() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}//Topping'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Topping.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải topping');
    }
  }
   static Future<List<Topping>> fetchToppings(int productId) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}//ChiTietSanPham/GetToppingsByProduct/$productId'),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);

    // ⚠️ Lọc null trước khi fromJson
    return jsonData
        .where((e) => e != null)
        .map((e) => Topping.fromJson(e))
        .toList();
  } else {
    throw Exception('Không lấy được topping theo sản phẩm');
  }
}

}
