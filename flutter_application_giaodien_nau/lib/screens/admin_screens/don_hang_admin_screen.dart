import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/donhang.dart';
import 'package:flutter_application_giaodien_nau/services/api_donhang.dart';

class DonHangAdminScreen extends StatefulWidget {
  final int chiNhanhId;

  const DonHangAdminScreen({super.key, required this.chiNhanhId});

  @override
  State<DonHangAdminScreen> createState() => _DonHangAdminScreenState();
}

class _DonHangAdminScreenState extends State<DonHangAdminScreen> {
  late Future<List<DonHangDTO>> futureDonHangs;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    futureDonHangs = ApiDonHang.getDonHangTheoChiNhanh(widget.chiNhanhId);
  }

  void _updateTrangThai(int donHangId) async {
    final trangThaiMoi = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.local_cafe),
            title: const Text('Đang chuẩn bị'),
            onTap: () => Navigator.pop(context, 'Đang chuẩn bị'),
          ),
          ListTile(
            leading: const Icon(Icons.delivery_dining),
            title: const Text('Đang giao'),
            onTap: () => Navigator.pop(context, 'Đang giao'),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Đã giao'),
            onTap: () => Navigator.pop(context, 'Đã giao'),
          ),
        ],
      ),
    );

    if (trangThaiMoi != null) {
      await ApiDonHang.updateTrangThaiDonHang(donHangId, trangThaiMoi);
      setState(() => fetchData()); // refresh sau khi cập nhật
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đơn hàng theo chi nhánh")),
      body: FutureBuilder<List<DonHangDTO>>(
        future: futureDonHangs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('❌ Lỗi: ${snapshot.error}'));
          }

          final donHangs = snapshot.data!;

          // Sắp xếp theo trạng thái
          donHangs.sort((a, b) {
            const order = {
              'Đang chuẩn bị': 0,
              'Đang giao': 1,
              'Đã giao': 2,
            };
            return (order[a.trangThai] ?? 99).compareTo(order[b.trangThai] ?? 99);
          });

          return ListView.builder(
            itemCount: donHangs.length,
            itemBuilder: (context, index) {
              final donHang = donHangs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("🧾 Mã đơn: ${donHang.id}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Chip(
                            label: Text(donHang.trangThai ?? "Chưa rõ",
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor: _trangThaiColor(donHang.trangThai),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("📍 Địa chỉ: ${donHang.diaChiGiaoHang ?? 'Không có'}"),
                      Text("📞 SĐT: ${donHang.sdt ?? 'Chưa có'}"),
                      const Divider(),
                     Column(
  children: donHang.chiTietDonHangs.map((ct) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              ct.hinhAnh != null
                  ? (ct.hinhAnh!.startsWith("http")
                      ? ct.hinhAnh!
                      : 'https://yourdomain.com${ct.hinhAnh}')
                  : 'https://via.placeholder.com/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ct.tenSanPham,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Size: ${ct.tenSize ?? '---'}, Đường: ${ct.tenLuongDuong ?? '---'}%"),
                if (ct.toppings.isNotEmpty)
                  Text("Topping: ${ct.toppings.join(', ')}"),
                Text("Số lượng: ${ct.soLuong}"),
                Text(
                  "Đơn giá: ${ct.donGia.toStringAsFixed(0)}đ",
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }).toList(),
),

                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => _updateTrangThai(donHang.id),
                          icon: const Icon(Icons.edit),
                          label: const Text("Cập nhật trạng thái"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006769),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      )
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

  Color _trangThaiColor(String? status) {
    switch (status) {
      case 'Đang chuẩn bị':
        return Colors.orange;
      case 'Đang giao':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
