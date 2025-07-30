class ChiNhanh {
  final int id;
  final String tenChiNhanh;
  final String diaChi;
  final double kinhDo;
  final double viDo;

  ChiNhanh({
    required this.id,
    required this.tenChiNhanh,
    required this.diaChi,
    required this.kinhDo,
    required this.viDo,
  });

  factory ChiNhanh.fromJson(Map<String, dynamic> json) {
    return ChiNhanh(
      id: json['id'],
      tenChiNhanh: json['tenChiNhanh'],
      diaChi: json['diaChi'],
      kinhDo: json['kinhDo'].toDouble(),
      viDo: json['viDo'].toDouble(),
    );
  }
}
