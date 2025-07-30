import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/chinhanh.dart';
import 'package:flutter_application_giaodien_nau/services/api_chinhanh.dart';
import 'don_hang_admin_screen.dart'; // Màn hiển thị đơn hàng theo chi nhánh

class ChonChiNhanhScreen extends StatefulWidget {
  const ChonChiNhanhScreen({super.key});

  @override
  State<ChonChiNhanhScreen> createState() => _ChonChiNhanhScreenState();
}

class _ChonChiNhanhScreenState extends State<ChonChiNhanhScreen> {
  late Future<List<ChiNhanh>> futureChiNhanhs;

  @override
  void initState() {
    super.initState();
    futureChiNhanhs = ApiChiNhanh.getAllChiNhanhs(); // Hàm này bạn sẽ có bên service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn chi nhánh')),
      body: FutureBuilder<List<ChiNhanh>>(
        future: futureChiNhanhs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("❌ Lỗi: ${snapshot.error}"));
          }

          final chiNhanhs = snapshot.data!;
          return ListView.builder(
            itemCount: chiNhanhs.length,
            itemBuilder: (context, index) {
              final cn = chiNhanhs[index];
              return ListTile(
                leading: const Icon(Icons.store),
                title: Text(cn.tenChiNhanh),
                subtitle: Text(cn.diaChi),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DonHangAdminScreen(chiNhanhId: cn.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
