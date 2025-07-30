import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/services/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/size.dart';
import '../models/luongduong.dart';
import '../models/topping.dart';
import '../services/api_product.dart';
import '../services/api_chitiet_sanpham.dart';
import '../services/api_giohang.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  List<SizeModel> sizes = [];
  List<LuongDuong> duongs = [];
  List<Topping> toppings = [];

  int? selectedSizeId = 1;
  int? selectedDuongId;
  List<int> selectedToppingIds = [];

  double giaHienTai = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      final fetchedProduct = await ApiProduct.fetchProductDetail(widget.productId);
      final fetchedSizes = await ApiChiTietSanPham.getSizes();
      final fetchedDuongs = await ApiChiTietSanPham.getDuong();
      final fetchedToppings = await ApiChiTietSanPham.getToppings();

      setState(() {
        product = fetchedProduct;
        sizes = fetchedSizes;
        duongs = fetchedDuongs;
        toppings = fetchedToppings;

        selectedSizeId = fetchedSizes.isNotEmpty ? fetchedSizes.first.id : null;
        selectedDuongId = null;
        selectedToppingIds = [];

        _capNhatGia();
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi fetchAll: $e");
    }
  }

  // void _capNhatGia() {
  //   double gia = (product?.giaThapNhat ?? 0).toDouble();

  //   final selectedSize = sizes.firstWhere(
  //     (s) => s.id == selectedSizeId,
  //     orElse: () => SizeModel(id: 1, giaCoBan: 0),
  //   );
  //   gia += selectedSize.giaCoBan ?? 0;

  //   gia += selectedToppingIds.fold(0, (sum, id) {
  //     final topping = toppings.firstWhere(
  //       (t) => t.id == id,
  //       orElse: () => Topping(id: -1, gia: 0),
  //     );
  //     return sum + (topping.gia ?? 0);
  //   });

  //   setState(() {
  //     giaHienTai = gia;
  //   });
  // }
void _capNhatGia() {
  double gia = (product?.giaThapNhat ?? 0).toDouble();

  // Áp dụng giảm giá nếu có
  if (product?.phanTramGiamGia != null && product!.phanTramGiamGia! > 0) {
    gia = gia * (1 - product!.phanTramGiamGia! / 100);
  }

  final selectedSize = sizes.firstWhere(
    (s) => s.id == selectedSizeId,
    orElse: () => SizeModel(id: 1, giaCoBan: 0),
  );
  gia += selectedSize.giaCoBan ?? 0;

  gia += selectedToppingIds.fold(0, (sum, id) {
    final topping = toppings.firstWhere(
      (t) => t.id == id,
      orElse: () => Topping(id: -1, gia: 0),
    );
    return sum + (topping.gia ?? 0);
  });

  setState(() {
    giaHienTai = gia;
  });
}

  Future<void> handleAddToCart() async {
  if (selectedSizeId == null || selectedDuongId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vui lòng chọn size và lượng đường")),
    );
    return;
  }

  // ✅ Lấy userId từ SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userId = await UserSession.getUserId();


  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Không tìm thấy thông tin người dùng")),
    );
    return;
  }

  final request = {
    "nguoiDungId": userId,
    "sanPhamId": product!.id,
    "sizeId": selectedSizeId,
    "luongDuongId": selectedDuongId,
    "toppingIds": selectedToppingIds,
    "soLuong": 1,
  };

  final response = await ApiGioHang.addToCart(request);

  if (response != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Đã thêm vào giỏ hàng")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Lỗi khi thêm vào giỏ hàng")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (isLoading || product == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product!.tenSanPham ?? "Chi tiết")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Container(
    height: MediaQuery.of(context).size.height * 0.3, // Chiều cao linh hoạt
    width: double.infinity,
    child: Image.network(
      product!.hinhAnh ?? '',
      fit: BoxFit.contain, // Sử dụng contain để hiển thị full ảnh không cắt xén
      alignment: Alignment.center,
      errorBuilder: (context, _, __) => const Icon(Icons.image),
    ),
  ),
),
                const SizedBox(height: 16),
                Text(
                  product!.tenSanPham ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
             Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Giá sau giảm
  Text(
  '${giaHienTai.toStringAsFixed(0)}đ',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  ),
),


    // Giá gốc gạch ngang nếu có giảm
    if (product?.phanTramGiamGia != null )
      Text(
        '${product?.giaThapNhat?.toStringAsFixed(0) ?? ''}đ',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      ),

    // Badge giảm giá (nếu muốn)
    if (product?.phanTramGiamGia != null  )
      Container(
        margin: EdgeInsets.only(top: 4),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '-${product?.phanTramGiamGia}%',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
  ],
),

                const SizedBox(height: 8),
                Text(product!.moTa ?? '', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                /// Size
                _buildSection("Chọn Size", sizes.map((s) {
                  final isSelected = s.id == selectedSizeId;
                  return ChoiceChip(
                    label: Text("${s.tenSize ?? ''} (+${s.giaCoBan?.toInt() ?? 0}đ)"),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedSizeId = s.id);
                      _capNhatGia();
                    },
                    selectedColor: Colors.brown.shade100,
                    labelStyle: TextStyle(color: isSelected ? Colors.brown : Colors.black),
                  );
                }).toList()),

                const SizedBox(height: 20),

                /// Lượng đường
                _buildSection("Chọn Lượng Đường", duongs.map((d) {
                  final isSelected = d.id == selectedDuongId;
                  return ChoiceChip(
                    label: Text(d.tenLuongDuong ?? ''),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedDuongId = d.id);
                    },
                    selectedColor: Colors.brown.shade100,
                    labelStyle: TextStyle(color: isSelected ? Colors.brown : Colors.black),
                  );
                }).toList()),

                const SizedBox(height: 20),

                /// Topping
                _buildSection("Topping (tuỳ chọn)", toppings.map((t) {
                  final isSelected = selectedToppingIds.contains(t.id);
                  return ChoiceChip(
                    label: Text("${t.tenTopping} (+${t.gia?.toInt()}đ)"),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedToppingIds.remove(t.id);
                        } else {
                          selectedToppingIds.add(t.id!);
                        }
                        _capNhatGia();
                      });
                    },
                    selectedColor: Colors.brown.shade100,
                    labelStyle: TextStyle(color: isSelected ? Colors.brown : Colors.black),
                  );
                }).toList()),
              ],
            ),
          ),

          /// Nút thêm giỏ
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: handleAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Thêm vào giỏ hàng", style: TextStyle(fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 10, children: children),
      ],
    );
  }
}
