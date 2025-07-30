class CheckoutReorderDto {
  final int? chiNhanhGanNhatId;
  final String? diaChi;
  final String? sdt;
  final String? ghiChu;
  final List<CartItemDto> chiTiet;

  CheckoutReorderDto({
    this.chiNhanhGanNhatId,
    this.diaChi,
    this.sdt,
    this.ghiChu,
    required this.chiTiet,
  });

  factory CheckoutReorderDto.fromJson(Map<String, dynamic> json) {
    return CheckoutReorderDto(
      chiNhanhGanNhatId: json['chiNhanhGanNhatId'],
      diaChi: json['diaChi'],
      sdt: json['sdt'],
      ghiChu: json['ghiChu'],
      chiTiet: (json['chiTiet'] as List)
          .map((e) => CartItemDto.fromJson(e))
          .toList(),
    );
  }
}

class CartItemDto {
  final int sanPhamId;
  final String? tenSanPham;
  final String? hinhAnh;
  final int? sizeId;
  final String? tenSize;
  final int? luongDuongId;
  final String? tenLuongDuong;
  final int soLuong;
  final double donGia;
  final List<int> toppingIds;
  final List<String> toppingNames;

  CartItemDto({
    required this.sanPhamId,
    this.tenSanPham,
    this.hinhAnh,
    this.sizeId,
    this.tenSize,
    this.luongDuongId,
    this.tenLuongDuong,
    required this.soLuong,
    required this.donGia,
    required this.toppingIds,
    required this.toppingNames,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    return CartItemDto(
      sanPhamId: json['sanPhamId'],
      tenSanPham: json['tenSanPham'],
      hinhAnh: json['hinhAnh'],
      sizeId: json['sizeId'],
      tenSize: json['tenSize'],
      luongDuongId: json['luongDuongId'],
      tenLuongDuong: json['tenLuongDuong'],
      soLuong: json['soLuong'],
      donGia: (json['donGia'] as num).toDouble(),
      toppingIds: List<int>.from(json['toppingIds']),
      toppingNames: List<String>.from(json['toppingNames']),
    );
  }
}
