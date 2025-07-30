class ProductFilter {
  String? keyword;
  int? danhMucId;
  int? minPrice;
  int? maxPrice;
  bool? coGiamGia;
  String? sortBy;

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (keyword != null && keyword!.isNotEmpty) params['keyword'] = keyword!;
    if (danhMucId != null) params['danhMucId'] = danhMucId.toString();
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    if (coGiamGia != null) params['coGiamGia'] = coGiamGia.toString();
    if (sortBy != null) params['sortBy'] = sortBy!;
    return params;
  }
}
