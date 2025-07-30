class Category {
  final int id;
  final String tenDanhMuc;

  Category({required this.id, required this.tenDanhMuc});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      tenDanhMuc: json['tenDanhMuc'],
    );
  }
}
