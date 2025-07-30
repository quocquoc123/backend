import 'topping.dart';

class CartItem {
  final int id;
  final String tenSanPham;
  final String hinhAnh;
  final String tenSize;
  final String tenLuongDuong;
  final int soLuong;
  final List<Topping> toppings;
  final double giaCoBan;
final double giaSanPham;

  CartItem({
    required this.id,
    required this.tenSanPham,
    required this.hinhAnh,
    required this.tenSize,
    required this.tenLuongDuong,
    required this.soLuong,
    required this.toppings,
    required this.giaCoBan,
        required this.giaSanPham,

  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      tenSanPham: json['tenSanPham'] ?? '',
      hinhAnh: json['hinhAnh'] ?? '',
      tenSize: json['tenSize'] ?? '',
      tenLuongDuong: json['tenLuongDuong'] ?? '',
      soLuong: json['soLuong'] ?? 1,
      giaCoBan: (json['giaCoBan'] as num?)?.toDouble() ?? 0,
      toppings: (json['toppings'] as List<dynamic>?)
              ?.map((t) => Topping.fromJson(t))
              .toList() ??
          [],
          giaSanPham: (json['giaSanPham'] as num?)?.toDouble() ?? 0,

    );
  }
}
