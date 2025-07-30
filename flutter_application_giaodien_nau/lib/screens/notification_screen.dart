import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/thong_bao.dart';
import 'package:flutter_application_giaodien_nau/services/api_thongbao.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final int userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<ThongBao>> _futureThongBao;

  @override
  void initState() {
    super.initState();
    _futureThongBao = ApiThongBao.getThongBaoByNguoiDung(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00425A),
        title: const Text("Thông báo"),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder<List<ThongBao>>(
        future: _futureThongBao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Lỗi khi tải thông báo'));
          }

          final thongBaos = snapshot.data ?? [];

          if (thongBaos.isEmpty) {
            return const Center(child: Text('Không có thông báo nào'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: thongBaos.length,
            itemBuilder: (context, index) {
              final tb = thongBaos[index];
              final formattedDate =
                  DateFormat('dd/MM/yyyy HH:mm').format(tb.ngayTao);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  leading: const Icon(Icons.notifications, color: Color(0xFF00425A), size: 28),
                  title: Text(
                    tb.noiDung,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
