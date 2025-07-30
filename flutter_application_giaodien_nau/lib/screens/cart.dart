import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/CartItem.dart';
import 'package:flutter_application_giaodien_nau/screens/checkout_screen.dart';
import 'package:flutter_application_giaodien_nau/screens/homescreen.dart';
import 'package:flutter_application_giaodien_nau/services/api_giohang.dart';
import 'package:flutter_application_giaodien_nau/services/user_session.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  List<CartItem> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
      final id = await UserSession.getUserId(); // ✅ được dùng

    final items = await ApiGioHang.getCartByUser(id!); // sửa thành ID động nếu có auth
    setState(() {
      cartItems = items;
      isLoading = false;
    });
  }

  int get tongSoLuong => cartItems.fold(0, (sum, item) => sum + (item.soLuong ?? 0));

  double get tongTien {
    return cartItems.fold(0.0, (sum, item) {
      final double giaSp = item.giaSanPham;
      final double giaSize = item.giaCoBan ?? 0;
      final double giaTopping = item.toppings.fold(0.0, (s, t) => s + (t.gia?.toDouble() ?? 0));
      final double itemTotal = (giaSp + giaSize + giaTopping) * item.soLuong;
      return sum + itemTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(userData: {})),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Text("Bạn có $tongSoLuong sản phẩm trong giỏ hàng"),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final double giaSp = item.giaSanPham ?? 0;
                      final double giaSize = item.giaCoBan ?? 0;
                      final double giaTopping = item.toppings.fold(0.0, (s, t) => s + (t.gia?.toDouble() ?? 0));
                      final double itemTotal = (giaSp + giaSize + giaTopping) * item.soLuong;

                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Xóa sản phẩm"),
                              content: const Text("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Không"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("Xóa"),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          final success = await ApiGioHang.deleteCartItem(item.id);
                          if (success) {
                               fetchCart();
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Xóa không thành công')),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.hinhAnh ?? '',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.tenSanPham ?? '',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text('${item.tenSize ?? ''} | ${item.tenLuongDuong ?? ''}'),
                                      if (item.toppings.isNotEmpty)
                                        Text(
                                          "Topping: ${item.toppings.map((t) => t.tenTopping).join(', ')}",
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${itemTotal.toStringAsFixed(0)}đ",
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                            IconButton(
  icon: const Icon(Icons.remove),
  onPressed: () async {
    if (item.soLuong > 1) {
      final success = await ApiGioHang.updateSoLuong(item.id, item.soLuong - 1);
      if (success) fetchCart();
    } else {
      // Nếu số lượng là 1, thì xóa khỏi giỏ hàng
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Xóa sản phẩm"),
          content: const Text("Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Không"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Xóa"),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final deleted = await ApiGioHang.deleteCartItem(item.id);
        if (deleted) {
          fetchCart();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không thể xóa sản phẩm")),
          );
        }
      }
    }
  },
),

                                              Text('${item.soLuong}'),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () async {
                                                  final success = await ApiGioHang.updateSoLuong(
                                                      item.id, item.soLuong + 1);
                                                  if (success) fetchCart();
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$tongSoLuong sản phẩm", style: const TextStyle(fontSize: 16)),
                      Text("${tongTien.toStringAsFixed(0)}đ",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
               onPressed: () async {
  final id = await UserSession.getUserId(); // ✅ được dùng
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CheckoutScreen(nguoiDungId: id!),
    ),
  );
},


                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Tiếp tục", style: TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ),
    );
  }
}
