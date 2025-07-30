class SizeModel {
  final int id;
  final String? tenSize;
  final double? giaCoBan;

  SizeModel({
    required this.id,
    this.tenSize,
    this.giaCoBan,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: (json['id'] as num).toInt(),
      tenSize: json['tenSize'],
      giaCoBan: json['giaCoBan'] != null ? (json['giaCoBan'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenSize': tenSize,
        'giaCoBan': giaCoBan,
      };
}
