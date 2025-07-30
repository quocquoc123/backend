class District {
  final String name;
  final List<String> wards;

  District({required this.name, required this.wards});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['ten'],
      wards: List<String>.from(json['phuong_xa']),
    );
  }
}
