import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {

    int nguoiDungId = 1; // ví dụ test cứng

    final List<dynamic> items = order['chiTiet'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn #${order['id']}'),
        backgroundColor: const Color(0xFF00425A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ngày tạo: ${order['ngayTao']}'),
            Text('Trạng thái: ${order['trangThai']}'),
            Text('Địa chỉ: ${order['diaChiGiao'] ?? 'N/A'}'),
            Text('Phí giao hàng: ${order['phiGiaoHang']} đ'),
            const SizedBox(height: 16),
            const Text('Danh sách sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text('${item['tenSanPham']} (${item['tenSize']})'),
                    subtitle: Text('Số lượng: ${item['soLuong']}'),
                    trailing: Text('${item['gia']} đ'),
                  );
                },
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Tổng tiền: ${order['tongTien']} đ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
