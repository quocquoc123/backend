  class BanTin {
    final int id;
    final String tieuDe;
    final String noiDung;
    final String? imageUrl; // ✅ chứa đường dẫn ảnh
    final DateTime? ngayTao;

    BanTin({
      required this.id,
      required this.tieuDe,
      required this.noiDung,
      this.imageUrl,
      this.ngayTao,
    });

    factory BanTin.fromJson(Map<String, dynamic> json) {
      return BanTin(
        id: json['id'],
        tieuDe: json['tieuDe'],
        noiDung: json['noiDung'],
        imageUrl: json['hinhAnh'], // ✅ SỬA TỪ 'imageUrl' thành 'hinhAnh'
        ngayTao: json['ngayTao'] != null
            ? DateTime.parse(json['ngayTao'])
            : null,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'tieuDe': tieuDe,
        'noiDung': noiDung,
        'hinhAnh': imageUrl, // ✅ đổi 'imageUrl' -> 'hinhAnh' để khớp với API
        'ngayTao': ngayTao?.toIso8601String(),
      };
    }
  }
