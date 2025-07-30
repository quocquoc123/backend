import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getAddressFromLatLngWithOSM(double lat, double lng) async {
  final url =
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lng';

  final response = await http.get(Uri.parse(url), headers: {
    'User-Agent': 'flutter-app' // OSM yêu cầu thêm user-agent
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['display_name'] ?? 'Không tìm thấy địa chỉ';
  } else {
    return '❌ Lỗi khi gọi OpenStreetMap API';
  }
}
