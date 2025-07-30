class User {
  final int? id;
  final String matKhau;
  final String hoTen;
  final String email;
  final String soDienThoai;
  final String? vaiTro;

  User({
    this.id,
    required this.matKhau,
    required this.hoTen,
    required this.email,
    required this.soDienThoai,
    this.vaiTro,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      matKhau: json['matKhau'],
      hoTen: json['hoTen'],
      email: json['email'],
      soDienThoai: json['soDienThoai'],
      vaiTro: json['vaiTro'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matKhau': matKhau,
      'hoTen': hoTen,
      'email': email,
      'soDienThoai': soDienThoai,
    };
  }
}
