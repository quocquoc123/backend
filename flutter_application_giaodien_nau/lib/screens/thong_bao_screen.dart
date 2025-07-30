import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/thong_bao.dart';
import 'package:flutter_application_giaodien_nau/services/api_thongbao.dart';
import 'package:intl/intl.dart';

class ThongBaoScreen extends StatefulWidget {
  final int nguoiDungId;

  const ThongBaoScreen({required this.nguoiDungId});

  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen> {
  late Future<List<ThongBao>> _futureThongBao;

  @override
  void initState() {
    super.initState();
    _futureThongBao = ApiThongBao.getThongBaoByNguoiDung(widget.nguoiDungId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông báo')),
      body: FutureBuilder<List<ThongBao>>(
        future: _futureThongBao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Lỗi: ${snapshot.error}'));

          final thongBaos = snapshot.data!;
          if (thongBaos.isEmpty) return Center(child: Text('Không có thông báo'));

          return ListView.builder(
            itemCount: thongBaos.length,
            itemBuilder: (context, index) {
              final tb = thongBaos[index];
              return ListTile(
                title: Text(tb.noiDung),
                subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(tb.ngayTao)),
                leading: Icon(Icons.notifications),
              );
            },
          );
        },
      ),
    );
  }
}
