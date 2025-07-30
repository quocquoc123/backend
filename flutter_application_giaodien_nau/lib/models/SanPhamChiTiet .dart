class SanPhamChiTiet {
  final int id;
  final int? sanPhamId;
  final int? sizeId;
  final int? toppingId;
  final int? luongDuongId;
  final double? gia;

  SanPhamChiTiet({
    required this.id,
    this.sanPhamId,
    this.sizeId,
    this.toppingId,
    this.luongDuongId,
    this.gia,
  });

  factory SanPhamChiTiet.fromJson(Map<String, dynamic> json) {
    return SanPhamChiTiet(
      id: (json['id'] as num).toInt(),
      sanPhamId: json['sanPhamId'],
      sizeId: json['sizeId'],
      toppingId: json['toppingId'],
      luongDuongId: json['luongDuongId'],
      gia: (json['gia'] as num?)?.toDouble(),
    );
  }
}
