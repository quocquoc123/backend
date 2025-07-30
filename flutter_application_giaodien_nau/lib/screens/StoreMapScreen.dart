

import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/chinhanhmap.dart';
import 'package:flutter_application_giaodien_nau/services/chinhanh_api.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


class StoreMapScreen extends StatefulWidget {
  @override
  _StoreMapScreenState createState() => _StoreMapScreenState();
}

class _StoreMapScreenState extends State<StoreMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  List<ChiNhanh> _chiNhanhs = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadChiNhanhs();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("✅ Đã cấp quyền truy cập vị trí.");
    } else {
      print("❌ Không được cấp quyền truy cập vị trí.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ứng dụng cần quyền truy cập vị trí để hiển thị bản đồ.")),
      );
    }
  }

  Future<void> _loadChiNhanhs() async {
    try {
      final chiNhanhs = await ChiNhanhApi.fetchChiNhanhs();

      for (var cn in chiNhanhs) {
        print("📍 Chi nhánh: ${cn.name}, Lat: ${cn.latitude}, Lng: ${cn.longitude}");
      }

      setState(() {
        _chiNhanhs = chiNhanhs;
        _markers.clear();

        _markers.addAll(
          chiNhanhs.where((cn) => cn.latitude != 0.0 && cn.longitude != 0.0).map((cn) {
            return Marker(
              markerId: MarkerId(cn.id.toString()),
              position: LatLng(cn.latitude, cn.longitude),
              infoWindow: InfoWindow(
                title: cn.name,
                snippet: cn.address,
              ),
            );
          }),
        );
      });

      if (_mapController != null && _chiNhanhs.isNotEmpty) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_chiNhanhs[0].latitude, _chiNhanhs[0].longitude),
            15,
          ),
        );
      }
    } catch (e) {
      print('❌ Lỗi khi tải chi nhánh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách chi nhánh.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bản đồ chi nhánh"),
        backgroundColor: Color(0xFF0F4C5C),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(10.776, 106.700), // Gần trung tâm TP.HCM
          zoom: 13.0,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;

          if (_chiNhanhs.isNotEmpty) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(_chiNhanhs[0].latitude, _chiNhanhs[0].longitude),
                15,
              ),
            );
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
