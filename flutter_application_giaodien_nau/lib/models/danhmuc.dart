import 'package:flutter_application_giaodien_nau/models/product.dart';

class DanhMuc {
  final int id;
  final String tenDanhMuc;
  final List<Product>? sanPhams;

  DanhMuc({
    required this.id,
    required this.tenDanhMuc,
    this.sanPhams,
  });

  factory DanhMuc.fromJson(Map<String, dynamic> json) {
    return DanhMuc(
      id: (json['id'] as num).toInt(),
      tenDanhMuc: json['tenDanhMuc'],
      sanPhams: json['sanPhams'] != null
          ? (json['sanPhams'] as List)
              .where((e) => e != null) // ✅ bỏ qua phần tử null
              .map((e) => Product.fromJson(e))
              .toList()
          : null,
    );
  }
}
