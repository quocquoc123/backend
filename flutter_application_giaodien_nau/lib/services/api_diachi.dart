
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<String> getGoogleAddressFromLatLng(double lat, double lng) async {
  const apiKey = 'AIzaSyC7HKW5wD9SV6ZgSDBt4ho8gccL16-Vmag'; // Key 2 bạn vừa tạo

  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey&language=vi';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData['status'] == 'OK') {
      return jsonData['results'][0]['formatted_address'];
    } else {
      return '❌ Không tìm thấy địa chỉ chi tiết: ${jsonData['status']}';
    }
  } else {
    return '❌ Lỗi khi gọi Google Maps API: ${response.statusCode}';
  }
}
Future<void> fetchAddressFromCoordinates(double lat, double lon) async {
  const apiKey = 'pk.9b4d6b775c8fe071958a7d3061846d4e';
  final url = Uri.parse('https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$lat&lon=$lon&format=json');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final address = data['display_name'];
    print('Địa chỉ: $address');
  } else {
    print('Lỗi: ${response.statusCode}');
  }
}

Future<LatLng?> fetchCoordinatesFromAddress(String address) async {
  const apiKey = 'pk.9b4d6b775c8fe071958a7d3061846d4e'; // LocationIQ API key

  final encodedAddress = Uri.encodeComponent(address);
  final url = Uri.parse(
    'https://us1.locationiq.com/v1/search.php?key=$apiKey&q=$encodedAddress&format=json',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    if (data.isNotEmpty) {
      final lat = double.tryParse(data[0]['lat']);
      final lon = double.tryParse(data[0]['lon']);
      if (lat != null && lon != null) {
        return LatLng(lat, lon);
      }
    }
    return null;
  } else {
    return null;
  }
}

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}
