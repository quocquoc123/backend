class ThongBao {
  final int id;
  final int? nguoiDungId;
  final String noiDung;
  final DateTime ngayTao;

  ThongBao({
    required this.id,
    required this.nguoiDungId,
    required this.noiDung,
    required this.ngayTao,
  });

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      id: json['id'],
      nguoiDungId: json['nguoiDungId'],
      noiDung: json['noiDung'] ?? '',
      ngayTao: DateTime.parse(json['ngayTao']),
    );
  }
}
