import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiVnPay {
  static Future<String?> createPaymentUrl(    int amount,
    String description,
    int nguoiDungId,
    String address,
    String note,
    String phone,
      int? chiNhanhId, // ✅ thêm
        String? tenChiNhanh, // ✅ thêm

) async {
  final body = jsonEncode({
  'amount': amount,
  'orderDescription': description,
  'orderType': 'billpayment',
  'name': 'Nau Coffee',
  'nguoiDungId': nguoiDungId,
  'diaChiGiaoHang': address,
  'ghiChu': note,
  'sdt': phone,
  'chiNhanhGanNhatId': chiNhanhId,
  'tenChiNhanh': tenChiNhanh,
});

print("📤 Body gửi đi cho VNPay: $body");
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/vnpay/create-payment'),
      headers: {'Content-Type': 'application/json'},
   body: jsonEncode({
  'amount': amount,
  'orderDescription': description,
  'orderType': 'billpayment',
  'name': 'Nau Coffee',
  'nguoiDungId': nguoiDungId,
  'diaChiGiaoHang': address,
  'ghiChu': note,
  'sdt': phone,
  'chiNhanhGanNhatId': chiNhanhId,     // 🔁 Đúng key
  'tenChiNhanh': tenChiNhanh,          // ✅ OK
  
}),

    );

   if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  return data['paymentUrl'];
} else {
  print('❌ Lỗi VNPay API statusCode: ${response.statusCode}');
  print('❗ Response body: ${response.body}');
  return null;
}

  }
 
}
