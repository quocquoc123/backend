import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/CartItem.dart';
import 'package:flutter_application_giaodien_nau/models/checkout_request.dart';
import 'package:flutter_application_giaodien_nau/models/chinhanh.dart';
import 'package:flutter_application_giaodien_nau/screens/vnpay_payment_screen.dart';
import 'package:flutter_application_giaodien_nau/services/api_chinhanh.dart';
import 'package:flutter_application_giaodien_nau/services/api_diachi.dart';
import 'package:flutter_application_giaodien_nau/services/api_donhang.dart';
import 'package:flutter_application_giaodien_nau/services/api_giohang.dart';
import 'package:flutter_application_giaodien_nau/services/api_vnpay.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  final int nguoiDungId;

  const CheckoutScreen({super.key, required this.nguoiDungId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _phoneController = TextEditingController(); // ✅ Controller cho số điện thoại
String? tenChiNhanhGanNhat;

  String _selectedMethod = 'Tiền mặt';
  final List<String> _methods = ['Tiền mặt', 'VNPay'];

  List<CartItem> cartItems = [];
  bool isLoading = true;
  bool isSubmitting = false;



//////////////////////
///Khoangcacdenchinhanh
List<ChiNhanh> chiNhanhList = [];

Future<void> _initLocationAndChiNhanh() async {
  try {
    chiNhanhList = await fetchChiNhanhs(); // ✅ KHÔNG cần ép kiểu
    await _getCurrentLocationAndFillAddress();
  } catch (e) {
    print('Lỗi khi khởi tạo vị trí và chi nhánh: $e');
  }
}


@override
void initState() {
  super.initState();
  fetchCart();
  _initLocationAndChiNhanh(); // ✅ Gọi hàm async đúng cách
  
}

int? chiNhanhGanNhatId;
String? tenChiNhanhDangChon;
int? chiNhanhDangChonId;
double? khoangCachGanNhat;

void _timChiNhanhGanNhat(double userLat, double userLng) {
  double minDistance = double.infinity;
  String? tenGanNhat;

  for (var chiNhanh in chiNhanhList) {
double distance = Geolocator.distanceBetween(
  userLat,
  userLng,
  chiNhanh.viDo,   // latitude
  chiNhanh.kinhDo  // longitude
);


    if (distance < minDistance) {
      minDistance = distance;
    chiNhanhGanNhatId = chiNhanh.id;
tenGanNhat = chiNhanh.tenChiNhanh;

    }
  }

 setState(() {
  tenChiNhanhGanNhat = tenGanNhat;
  chiNhanhGanNhatId = chiNhanhGanNhatId;
  khoangCachGanNhat = minDistance;

  // Mặc định đang chọn chi nhánh gần nhất
  tenChiNhanhDangChon = tenGanNhat;
  chiNhanhDangChonId = chiNhanhGanNhatId;
});

}
//////////////////chonthucongchinhanh

void chonChiNhanhThuCong(BuildContext context) async {
  final selected = await showModalBottomSheet<ChiNhanh>(
    context: context,
    builder: (context) => ListView(
      children: chiNhanhList.map((cn) {
        return ListTile(
          title: Text(cn.tenChiNhanh),
          subtitle: Text(cn.diaChi),
          onTap: () => Navigator.pop(context, cn),
        );
      }).toList(),
    ),
  );

  if (selected != null) {
    final viTriHienTai = await Geolocator.getCurrentPosition();
final distance = Geolocator.distanceBetween(
  viTriHienTai.latitude,
  viTriHienTai.longitude,
  selected.viDo,   // ✅ latitude
  selected.kinhDo  // ✅ longitude
);


    setState(() {
      chiNhanhDangChonId = selected.id;
      tenChiNhanhDangChon = selected.tenChiNhanh;
      khoangCachGanNhat = distance; // ✅ Cập nhật khoảng cách mới
    });
  }
}


///
/////laydiachi

Future<void> _getCurrentLocationAndFillAddress() async {
  const apiKey = 'pk.9b4d6b775c8fe071958a7d3061846d4e';

  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dịch vụ vị trí đang tắt')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn đã từ chối quyền truy cập vị trí')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối vĩnh viễn')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final lat = position.latitude;
    final lon = position.longitude;
_timChiNhanhGanNhat(lat, lon);

    final url = Uri.parse(
      'https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$lat&lon=$lon&format=json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
  final address = data['display_name'];
print("🏠 Địa chỉ từ LocationIQ: $address");


      setState(() {
        _addressController.text = address;

      });
print("📦 Gửi địa chỉ: ${_addressController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lấy địa chỉ tự động thành công')),
        
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lấy địa chỉ từ vị trí')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi: $e')),
    );
  }
  
}



///............
  Future<void> fetchCart() async {
    final items = await ApiGioHang.getCartByUser(widget.nguoiDungId);
    setState(() {
      cartItems = items;
      isLoading = false;
    });
  }

  double tinhTongTien() {
    return cartItems.fold(0.0, (sum, item) {
      final giaSp = item.giaSanPham ?? 0;
      final giaSize = item.giaCoBan ?? 0;
      final giaTopping = item.toppings.fold(0.0, (s, t) => s + (t.gia?.toDouble() ?? 0));
      return sum + (giaSp + giaSize + giaTopping) * item.soLuong;
    });
  }
bool _kiemTraDiaChiTrongHCM(String address) {
  final addressLower = address.toLowerCase();
  return addressLower.contains('hồ chí minh') ||
         addressLower.contains('ho chi minh') ||
         addressLower.contains('hcm');
}

 void _submitOrder() async {
  final addressLower = _addressController.text.toLowerCase();
  final inHCM = addressLower.contains('hồ chí minh') ||
                addressLower.contains('ho chi minh') ||
                addressLower.contains('hcm');

  if (!inHCM) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Không hỗ trợ"),
        content: const Text("Chúng tôi chỉ giao hàng trong khu vực TP. Hồ Chí Minh."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    return; // ❌ Không tiếp tục nếu không ở HCM
  }

  setState(() => isSubmitting = true);

  final request = CheckoutRequest(
    nguoiDungId: widget.nguoiDungId,
    diaChiGiaoHang: _addressController.text,
    phuongThucThanhToan: _selectedMethod,
    ghiChu: _noteController.text,
    sdt: _phoneController.text,
    chiNhanhId: chiNhanhDangChonId ?? chiNhanhGanNhatId ?? 1,
  );

  final success = await ApiDonHang.checkout(request);

  setState(() => isSubmitting = false);

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt hàng thành công')),
    );
    Navigator.pop(context); // ✅ Quay về sau khi đặt hàng
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt hàng thất bại')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DANH SÁCH SẢN PHẨM
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final giaSp = item.giaSanPham ?? 0;
                        final giaSize = item.giaCoBan ?? 0;
                        final giaTopping = item.toppings.fold(0.0, (s, t) => s + (t.gia?.toDouble() ?? 0));
                        final tongTienItem = (giaSp + giaSize + giaTopping) * item.soLuong;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.network(item.hinhAnh ?? '', width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(item.tenSanPham ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Size: ${item.tenSize} | Đường: ${item.tenLuongDuong}"),
                                if (item.toppings.isNotEmpty)
                                  Text("Topping: ${item.toppings.map((t) => t.tenTopping).join(', ')}"),
                                Text("Số lượng: ${item.soLuong}"),
                              ],
                            ),
                            trailing: Text("${tongTienItem.toStringAsFixed(0)}đ"),
                          ),
                        );
                      },
                    ),
                  ),

                  // TỔNG TIỀN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng tiền:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("${tinhTongTien().toStringAsFixed(0)}đ",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // NHẬP THÔNG TIN
          Row(
  children: [
    Expanded(
      child: TextField(
  controller: _addressController,
  decoration: InputDecoration(
    labelText: "Nhập địa chỉ để tìm chi nhánh gần nhất",
    suffixIcon: IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        final inputAddress = _addressController.text;
        if (inputAddress.isEmpty) return;

        final coords = await fetchCoordinatesFromAddress(inputAddress);
        if (coords != null) {
          _timChiNhanhGanNhat(coords.lat, coords.lng);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Không tìm được tọa độ từ địa chỉ")),
          );
        }
      },
    ),
  ),
),

    ),
    IconButton(
      icon: const Icon(Icons.my_location),
      tooltip: "Tự động lấy địa chỉ",
      onPressed: _getCurrentLocationAndFillAddress,
    ),
  ],
),
// if (tenChiNhanhGanNhat != null && tenChiNhanhGanNhat!.isNotEmpty)
//   Padding(
//     padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
//     child: Row(
//       children: [
//         const Icon(Icons.location_on, color: Colors.green),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             'Chi nhánh gần nhất: $tenChiNhanhGanNhat',
//             style: const TextStyle(fontSize: 16, color: Colors.green),
//           ),
//         ),
//       ],
//     ),
//   ),
   Padding(
  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
  child: Row(
    children: [
      const Icon(Icons.store, color: Colors.green),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          tenChiNhanhDangChon != null
              ? "Chi nhánh: $tenChiNhanhDangChon"
              : "Đang xác định chi nhánh gần nhất...",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      if (khoangCachGanNhat != null)
        Text(" (${(khoangCachGanNhat! / 1000).toStringAsFixed(1)} km)",
            style: const TextStyle(color: Colors.grey)),
      TextButton(
        onPressed: () {
          print("👉 Nhấn chọn chi nhánh");
          chonChiNhanhThuCong(context);
        },
        child: const Text("Thay đổi"),
      ),
    ],
  ),
),


                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedMethod,
                    items: _methods.map((method) {
                      return DropdownMenuItem(value: method, child: Text(method));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedMethod = value);
                      }
                    },
                    decoration: const InputDecoration(labelText: "Phương thức thanh toán"),
                  ),
                  TextField(
  controller: _phoneController,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    labelText: "Số điện thoại",
    hintText: "Nhập số điện thoại người nhận",
  ),
),
SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {

    final address = _addressController.text;

     if (!_kiemTraDiaChiTrongHCM(address)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Không hỗ trợ"),
          content: const Text("Chúng tôi chỉ giao hàng trong khu vực TP. Hồ Chí Minh."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    if (_selectedMethod == "Tiền mặt") {
      _submitOrder(); // COD
    } else if (_selectedMethod == "VNPay") {
      final amount = tinhTongTien().toInt();
      final description = 'Thanh toán NauCoffee NguoiDungId:${widget.nguoiDungId}';
print("🧭 Địa chỉ hiện tại trong TextField: ${_addressController.text}");

 final paymentUrl = await ApiVnPay.createPaymentUrl(
  amount,
  description,
  widget.nguoiDungId,
  _addressController.text,
  _noteController.text,
  _phoneController.text,
  chiNhanhDangChonId ?? chiNhanhGanNhatId ?? 1,
  tenChiNhanhDangChon ?? tenChiNhanhGanNhat ?? "Không rõ", // ✅ thêm dòng này
);
final address = _addressController.text; // OK
print("🧭 Địa chỉ gửi đi: $address");




      if (paymentUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VNPayPaymentScreen(paymentUrl: paymentUrl)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          
          const SnackBar(content: Text('Không thể tạo link thanh toán')),
          
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa hỗ trợ phương thức này')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.brown,
    foregroundColor: Colors.white,
    minimumSize: const Size.fromHeight(50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  child: const Text("Xác nhận đặt hàng", style: TextStyle(fontSize: 18)),
),


                ],
              ),
            ),
    );
  }
}
