class CheckoutRequest {
  final int nguoiDungId;
  final String diaChiGiaoHang;
  final String phuongThucThanhToan;
  final String ghiChu;
  final String sdt;
  final int? chiNhanhId; // ✅ thêm

  CheckoutRequest({
    required this.nguoiDungId,
    required this.diaChiGiaoHang,
    required this.phuongThucThanhToan,
    required this.ghiChu,
    required this.sdt,
    this.chiNhanhId, // ✅ thêm
  });

 Map<String, dynamic> toJson() {
  return {
    'nguoiDungId': nguoiDungId,
    'diaChiGiaoHang': diaChiGiaoHang,
    'phuongThucThanhToan': phuongThucThanhToan,
    'ghiChu': ghiChu,
    'sdt': sdt,
    'chiNhanhGanNhatId': chiNhanhId, // ✅ sửa lại tên key
  };
  
}

}
