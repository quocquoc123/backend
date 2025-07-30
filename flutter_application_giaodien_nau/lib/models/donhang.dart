class DonHangDTO {
  final int id;
  final String? ngayDat;
  final String? trangThai;
  final double tongTien;
  final String? diaChiGiaoHang;
  final String? phuongThucThanhToan;
  final String? ghiChu;
  final String? sdt;
  final int? chiNhanhGanNhatId;
  final String? tenChiNhanh;
  final List<ChiTietDonHangDTO> chiTietDonHangs;

  DonHangDTO({
    required this.id,
    this.ngayDat,
    this.trangThai,
    required this.tongTien,
    this.diaChiGiaoHang,
    this.phuongThucThanhToan,
    this.ghiChu,
    this.sdt,
    this.chiNhanhGanNhatId,
    this.tenChiNhanh,
    required this.chiTietDonHangs,
  });

  factory DonHangDTO.fromJson(Map<String, dynamic> json) {
    return DonHangDTO(
      id: json['id'],
      ngayDat: json['ngayDat'],
      trangThai: json['trangThai'],
      tongTien: (json['tongTien'] ?? 0).toDouble(),
      diaChiGiaoHang: json['diaChiGiaoHang'],
      phuongThucThanhToan: json['phuongThucThanhToan'],
      ghiChu: json['ghiChu'],
      sdt: json['sdt'],
      chiNhanhGanNhatId: json['chiNhanhGanNhatId'],
      tenChiNhanh: json['tenChiNhanh'],
      chiTietDonHangs: (json['chiTietDonHangs'] as List)
          .map((e) => ChiTietDonHangDTO.fromJson(e))
          .toList(),
    );
  }
}

class ChiTietDonHangDTO {
  final String tenSanPham;
  final String? hinhAnh;
  final String? tenSize;
  final String? tenLuongDuong;
  final int soLuong;
  final double donGia;
  final List<String> toppings;

  ChiTietDonHangDTO({
    required this.tenSanPham,
    this.hinhAnh,
    this.tenSize,
    this.tenLuongDuong,
    required this.soLuong,
    required this.donGia,
    required this.toppings,
  });

  factory ChiTietDonHangDTO.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHangDTO(
      tenSanPham: json['tenSanPham'],
      hinhAnh: json['hinhAnh'],
      tenSize: json['tenSize'],
      tenLuongDuong: json['tenLuongDuong'],
      soLuong: json['soLuong'],
      donGia: (json['donGia'] ?? 0).toDouble(),
      toppings: List<String>.from(json['toppings']),
    );
  }
}
