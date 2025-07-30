import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_giaodien_nau/models/bantin.dart';
import 'package:flutter_application_giaodien_nau/models/product.dart';
import 'package:flutter_application_giaodien_nau/screens/cart.dart';
import 'package:flutter_application_giaodien_nau/screens/info.dart';
import 'package:flutter_application_giaodien_nau/screens/notification_screen.dart';
import 'package:flutter_application_giaodien_nau/screens/store.dart';
import 'package:flutter_application_giaodien_nau/services/ProductProvider.dart';
import 'package:flutter_application_giaodien_nau/services/api_bantin.dart';
import 'package:flutter_application_giaodien_nau/services/api_product.dart';
import 'package:flutter_application_giaodien_nau/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyHomePage extends StatefulWidget {
   final Map<String, dynamic> userData;                 // 👈 thêm dòng này



const MyHomePage({super.key, required this.userData});
  @override
  State<MyHomePage> createState() => __MyHomePageStateState();
  
}
     final Color primaryColor = Color(0xFF00425A);

class __MyHomePageStateState extends State<MyHomePage> {
late Map<String, dynamic> _userData;
  @override
  void initState() {
    super.initState();
    _userData = Map<String, dynamic>.from(widget.userData); // ✅ clone dữ liệu từ widget
  }
  //tknc
    final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  //tknc
///timkiem
TextEditingController _searchController = TextEditingController();
List<Product> _searchResults = [];
bool _isLoading = false;
void _showFilterDialog(BuildContext context) {
  String? selectedDanhMucId;
  bool coGiamGia = false;
  String? sortBy;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Lọc sản phẩm nâng cao'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Từ khóa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Tất cả')),
                  DropdownMenuItem(value: '1', child: Text('Cà phê')),
                  DropdownMenuItem(value: '2', child: Text('Trà')),
                ],
                onChanged: (value) => selectedDanhMucId = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _minPriceController,
                decoration: const InputDecoration(
                  labelText: 'Giá tối thiểu (VNĐ)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _maxPriceController,
                decoration: const InputDecoration(
                  labelText: 'Giá tối đa (VNĐ)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Có giảm giá'),
                value: coGiamGia,
                onChanged: (value) {
                  coGiamGia = value ?? false;
                  (context as Element).markNeedsBuild();
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sắp xếp',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Mặc định')),
                  DropdownMenuItem(value: 'ten', child: Text('Theo tên')),
                  DropdownMenuItem(value: 'gia_tang', child: Text('Giá tăng dần')),
                  DropdownMenuItem(value: 'gia_giam', child: Text('Giá giảm dần')),
                ],
                onChanged: (value) => sortBy = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              _minPriceController.clear();
              _maxPriceController.clear();
              Provider.of<ProductProvider>(context, listen: false).clear();
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<ProductProvider>(context, listen: false);
              final prefs = await SharedPreferences.getInstance();
              final int? userId = prefs.getInt('userId');

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không tìm thấy ID người dùng')),
                );
                return;
              }

              setState(() => _isLoading = true);
              await provider.fetchFilteredProducts(
                nguoiDungId: userId,
                keyword: _searchController.text.isNotEmpty ? _searchController.text : null,
                danhMucId: selectedDanhMucId != null ? int.tryParse(selectedDanhMucId!) : null,
                minPrice: _minPriceController.text.isNotEmpty ? int.tryParse(_minPriceController.text) : null,
                maxPrice: _maxPriceController.text.isNotEmpty ? int.tryParse(_maxPriceController.text) : null,
                coGiamGia: coGiamGia,
                sortBy: sortBy,
              );
              setState(() => _isLoading = false);
              Navigator.pop(context);
            },
            child: const Text('Áp dụng'),
          ),
        ],
      );
    },
  );
}
void _onSearchChanged(String keyword) async {
  final provider = Provider.of<ProductProvider>(context, listen: false);
  final prefs = await SharedPreferences.getInstance();
  final int? userId = prefs.getInt('userId');

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không tìm thấy ID người dùng')),
    );
    return;
  }

  if (keyword.isEmpty) {
    provider.clear();
    return;
  }

  setState(() => _isLoading = true);
  await provider.fetchFilteredProducts(
    nguoiDungId: userId,
    keyword: keyword,
  );
  setState(() => _isLoading = false);
}
Widget _buildSearchResult(Product product) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(productId: product.id),
        ),
      );
    },
    child: ListTile(
      leading: product.hinhAnh != null
          ? Image.network(product.hinhAnh!, width: 50, height: 50, fit: BoxFit.cover)
          : const Icon(Icons.image_not_supported),
      title: Text(product.tenSanPham ?? ''),
      subtitle: Text(
        product.giaSauGiam != null
            ? '${product.giaSauGiam!.toStringAsFixed(0)}đ'
            : '${product.giaThapNhat?.toStringAsFixed(0) ?? 0}đ',
        style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

  //cuoitimkiem
  int _selectedIndex = 0;
 void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Đang ở tab đó thì không làm gì

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
       
        break;
      case 1:
 Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );        break;
      case 3:
     Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StoreScreen()),
        );        break;
      case 4:
      
      
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UserProfileScreen(userData: widget.userData),
  ),
);        break;    }
  }
  @override
  Widget build(BuildContext context) {
     print('📦 userData = ${widget.userData}');
    return  Scaffold( 
           appBar: AppBar(
            
           centerTitle: true,
    
           title: Column(
           mainAxisSize: MainAxisSize.min, 
           children: [
          Text(
           'NÂU COFFEE',
           style: TextStyle(
           color: Colors.white,
           fontSize: 24,
           fontWeight: FontWeight.bold,
            ),
           ),
           Text(
           'Coffee and Tea', 
            style: TextStyle(
            color: Colors.white70,  
            fontSize: 14,
            fontWeight: FontWeight.normal,
            ),
          ),
       ],
      ),
          backgroundColor: Color(0xFF00425A),

    ),
   

       body: SingleChildScrollView(
       child: Padding(
       padding: EdgeInsets.all(16), // Cho đẹp & không sát mép
       child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
           SizedBox(height: 20),
       Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  
    // Logo + Tên người dùng
    Row(
      children: [
        // Logo
        CircleAvatar(
          backgroundImage: AssetImage('assets/logo.png'), // Đường dẫn ảnh
          radius: 20,
        ),
        SizedBox(width: 8),
        // Tên người dùng
     Text(
  'Xin chào, ${widget.userData['hoTen'] ?? 'Người dùng'}!',
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
),

      ],
    ),
    
    Row(
      children: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
         // hàm tìm kím
          },
        ),
         IconButton(
  icon: const Icon(Icons.person),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserProfileScreen(userData: widget.userData),
      ),
    );
  },
),
      IconButton(
  icon: Icon(Icons.notifications),
  onPressed: () async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(userId: userId),
        ),
      );
    } else {
      // Xử lý khi không tìm thấy userId, ví dụ: show dialog, toast, v.v.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy ID người dùng")),
      );
    }
  },
),


      ],
    ),
  ],
  
), 

Padding(
  padding: const EdgeInsets.all(8.0),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: 'Tìm kiếm sản phẩm...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () => _showFilterDialog(context),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onChanged: _onSearchChanged,
  ),
),
if (_isLoading)
  const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(child: CircularProgressIndicator()),
  ),
Consumer<ProductProvider>(
  builder: (context, provider, child) {
    if (provider.products.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'KẾT QUẢ LỌC',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00425A),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              return _buildSearchResult(provider.products[index]);
            },
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  },
),


 CarouselSlider(
  options: CarouselOptions(
    height: MediaQuery.of(context).size.height * 0.25, // Chiều cao 25% màn hình
    autoPlay: true,
    enlargeCenterPage: true,
    aspectRatio: 16/9,
    viewportFraction: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height 
        ? 0.4 // Giảm viewportFraction khi ngang
        : 0.8, // Giữ nguyên khi dọc
    enableInfiniteScroll: true, // Cho phép cuộn vô hạn
  ),
  items: [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ].map((imagePath) {
    return Builder(
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25, // Đặt chiều cao cố định cho Container
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), // Đảm bảo bo góc cho Container
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
        );
      },
    );
  }).toList(),
),
    
Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Khung Giao hàng
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/giaohang.png',
                     height: 100,
                  ),
                  SizedBox(height: 8),
                  // Text(
                  //   'Giao hàng',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // Khung Lấy tận nơi
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                      Image.asset(
                    'assets/images/laytannoi.png',
                     height: 100,
                  ),
                  SizedBox(height: 8),
                  // Text(
                  //   'Lấy tận nơi',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,S
                  //     color: Colors.black87,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Dòng chữ căn giữa phía dưới 2 khung
      SizedBox(height: 12),
      Center(
        child: Text(
          'Khung giờ áp dụng đặt hàng từ 7:00 đến 21:00',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFB66E41), // màu nâu nhạt hơi cam
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      SizedBox(height: 24),

/// Tiêu đề Best Seller
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'BEST SELLER ★',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00425A),
      ),
    ),
    TextButton(
      onPressed: () {
        // TODO: Chuyển sang màn hình tất cả sản phẩm
      },
      child: Text(
        'Xem tất cả',
        style: TextStyle(color: Colors.brown),
      ),
    ),
  ],
),
// Giao diện widget hiển thị danh sách sản phẩm từ API
 SizedBox(
  height: 240,
  child: FutureBuilder<List<Product>>(
    future: ApiProduct.fetchProducts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Lỗi: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('Không có sản phẩm'));
      }

      final products = snapshot.data!;

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
         return _buildProductCard(
  context: context,
  imagePath: product.hinhAnh ?? '',
  name: product.tenSanPham ?? '',
  price: product.giaThapNhat ?? 0,
  productId: product.id,
    giaSauGiam: product.giaSauGiam, // 👈 thêm dòng này

);


        },
      );
    },
  ),
),

/// Tiêu đề
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'BẢN TIN NÂU COFFEE 📰',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00425A),
      ),
    ),
    TextButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => BanTinScreen()),
        // );
      },
      child: Text('Xem tất cả', style: TextStyle(color: Colors.brown)),
    ),
  ],
),
SizedBox(
  height: 200,
  child: FutureBuilder<List<BanTin>>(
    future: BanTinApi.fetchBanTins(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Lỗi: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('Không có bản tin'));
      }

      final banTins = snapshot.data!;

      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: banTins.length,
          itemBuilder: (context, index) {
            final tin = banTins[index];
            return Container(
              width: 160,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.orange.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => BanTinDetailScreen(
                  //       banTinId: tin.id,
                  //       banTin: null,
                  //     ),
                  //   ),
                  // );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        tin.imageUrl ?? '',
                        height: 90,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 90,
                          color: Colors.grey[200],
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🌿 Nhãn loại tin + icon mùa hè
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wb_sunny,
                                  size: 12, color: Colors.orange.shade600),
                              SizedBox(width: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'TIN TỨC - SỰ KIỆN',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange.shade800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            tin.tieuDe,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF00425A),
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.emoji_nature,
                                  size: 13,
                                  color:
                                      const Color.fromARGB(255, 23, 13, 9)),
                              SizedBox(width: 4),
                              Text(
                                tin.ngayTao != null
                                    ? '${tin.ngayTao!.day.toString().padLeft(2, '0')}/'
                                        '${tin.ngayTao!.month.toString().padLeft(2, '0')}/'
                                        '${tin.ngayTao!.year}'
                                    : 'Không rõ',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ),
),

  
    ],
  ),
),
        ],
        
      ),
      
    ),
    
    
   ),

        
       bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex, // xác định tab đang được chọn
  onTap: _onItemTapped,         // gán callback khi chọn tab
  selectedItemColor: primaryColor,
  unselectedItemColor: Colors.grey,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
    BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: 'Đặt nước'),
    BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Code'),
    BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Cửa hàng'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
  ],
),

    );
  }
}
//////////////////////////////////////

Widget _buildProductCard({
  required BuildContext context,
  required String? imagePath,
  required String name,
  required double price, // 👈 sửa từ int → double
  required int productId,
  double? giaSauGiam, // 👈 sửa từ int? → double?
}) {

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(productId: productId),
        ),
      );
    },
    child: Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: (imagePath != null && imagePath.startsWith('http'))
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  )
                : const Icon(Icons.image, size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
        giaSauGiam != null && giaSauGiam < price
  ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${price.toStringAsFixed(0)}đ',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          '${giaSauGiam.toStringAsFixed(0)}đ',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    )
  : Text(
      '${price.toStringAsFixed(0)}đ',
      style: const TextStyle(
        fontSize: 15,
        color: Colors.brown,
        fontWeight: FontWeight.bold,
      ),
    ),

          const Icon(Icons.add_circle_outline, color: Colors.brown),
        ],
      ),
    ),
  );
}