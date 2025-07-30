class Product {
  final int id;
  final String? tenSanPham;
  final String? moTa;
  final String? hinhAnh;
  final double? giaThapNhat;
  final int? phanTramGiamGia;
final double? giaSauGiam;

 Product({
  required this.id,
  this.tenSanPham,
  this.moTa,
  this.hinhAnh,
  this.giaThapNhat,
  this.phanTramGiamGia,
  this.giaSauGiam, // thêm vào
});


 factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'],
    tenSanPham: json['tenSanPham'],
    moTa: json['moTa'],
    hinhAnh: json['hinhAnh'],
    giaThapNhat: (json['giaThapNhat'] as num?)?.toDouble(),
    phanTramGiamGia: json['phanTramGiamGia'],
    giaSauGiam: (json['giaSauGiam'] as num?)?.toDouble(),
  );
}
}
