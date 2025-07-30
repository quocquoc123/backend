import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/donhang.dart';
import '../models/checkoutreorder.dart';
import '../services/api_donhang.dart';

class LichSuDonHangScreen extends StatefulWidget {
  const LichSuDonHangScreen({super.key});

  @override
  State<LichSuDonHangScreen> createState() => _LichSuDonHangScreenState();
}

class _LichSuDonHangScreenState extends State<LichSuDonHangScreen> {
  Future<List<DonHangDTO>>? _donHangFuture;

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchData();
  }

  Future<void> _loadUserAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    setState(() {
      _donHangFuture = ApiDonHang.getLichSuDonHang(userId);
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🧾 Lịch sử đơn hàng")),
      body: FutureBuilder<List<DonHangDTO>>(
        future: _donHangFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Đã xảy ra lỗi: ${snapshot.error}"),
            );
          }

          final donHangs = snapshot.data!;
          if (donHangs.isEmpty) {
            return const Center(child: Text("☕ Bạn chưa có đơn hàng nào"));
          }

          return ListView.builder(
            itemCount: donHangs.length,
            itemBuilder: (context, index) {
              final don = donHangs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🆔 Đơn hàng #${don.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("📅 Ngày đặt: ${don.ngayDat}"),
                      Text("📦 Trạng thái: ${don.trangThai}"),
                      Text("💳 Thanh toán: ${don.phuongThucThanhToan ?? "Chưa rõ"}"),
                      Text("💵 Tổng tiền: ${don.tongTien.toStringAsFixed(0)} đ"),
                      Text("🏪 Chi nhánh: ${don.tenChiNhanh ?? "Không rõ"}"),
                      const Divider(),
                      ...don.chiTietDonHangs.map((ct) => ListTile(
                            leading: ct.hinhAnh != null
                                ? Image.network(ct.hinhAnh!, width: 40, height: 40, fit: BoxFit.cover)
                                : const Icon(Icons.local_cafe),
                            title: Text("${ct.tenSanPham} (${ct.tenSize ?? ''})"),
                            subtitle: Text(
                                "SL: ${ct.soLuong}, Đường: ${ct.tenLuongDuong ?? '-'}, Topping: ${ct.toppings.join(', ')}"),
                            trailing: Text("${ct.donGia.toStringAsFixed(0)} đ"),
                          )),
                      const SizedBox(height: 10),
                    
                    ],
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
