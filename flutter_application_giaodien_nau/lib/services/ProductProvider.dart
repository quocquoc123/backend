  import 'package:flutter/material.dart';
  import '../models/product.dart';
  import '../services/api_product.dart';

  class ProductProvider with ChangeNotifier {
    List<Product> _products = [];
    bool _isLoading = false;

    List<Product> get products => _products;
    bool get isLoading => _isLoading;

    Future<void> fetchFilteredProducts({
      required int nguoiDungId,
      String? keyword,
      int? danhMucId,
      int? minPrice,
      int? maxPrice,
      bool? coGiamGia,
      String? sortBy,
    }) async {
      _isLoading = true;
      notifyListeners();

      try {
        _products = await ApiProduct.filterByNguoiDung(
          nguoiDungId: nguoiDungId,
          keyword: keyword,
          danhMucId: danhMucId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          coGiamGia: coGiamGia,
          sortBy: sortBy,
        );
      } catch (e) {
        print('❌ Lỗi khi lọc sản phẩm: $e');
        _products = [];
      }

      _isLoading = false;
      notifyListeners();
    }

    void clear() {
      _products = [];
      notifyListeners();
    }
  }
