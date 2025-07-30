class Topping {
  final int id;
  final String? tenTopping;
  final double? gia;

  Topping({
    required this.id,
    this.tenTopping,
    this.gia,
  });

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      id: (json['id'] as num).toInt(), // ✅ Bắt buộc
      tenTopping: json['tenTopping'],
      gia: (json['gia'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenTopping': tenTopping,
        'gia': gia,
      };
}
