class LuongDuong {
  final int id;
  final String? tenLuongDuong;

  LuongDuong({
    required this.id,
    this.tenLuongDuong,
  });

  factory LuongDuong.fromJson(Map<String, dynamic> json) {
    return LuongDuong(
      id: (json['id'] as num).toInt(), // ✅ Bắt buộc
      tenLuongDuong: json['tenLuongDuong'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenLuongDuong': tenLuongDuong,
      };
}
