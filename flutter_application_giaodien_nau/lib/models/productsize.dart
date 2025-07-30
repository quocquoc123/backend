class ProductSize {
  final int id;
  final String tenSize;
  final double gia;

  ProductSize({required this.id, required this.tenSize, required this.gia});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'],
      tenSize: json['tenSize'],
      gia: (json['gia'] as num).toDouble(),
    );
  }
}
class ProductSizeCart {
  final int maSanPham;
  final int maSize;
  final String tenSize;
  final double gia;

  ProductSizeCart({
    required this.maSanPham,
    required this.maSize,
    required this.tenSize,
    required this.gia,
  });

  factory ProductSizeCart.fromJson(Map<String, dynamic> json) {
    return ProductSizeCart(
      maSanPham: json['maSanPham'],
      maSize: json['maSize'],
      tenSize: json['tenSize'],
      gia: json['gia'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSanPham': maSanPham,
      'maSize': maSize,
      'tenSize': tenSize,
      'gia': gia,
    };
  }
}

