import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/screens/StoreMapScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
  
}

class _StoreScreenState extends State<StoreScreen> {
  



  int selectedViewIndex = 0;
  String selectedCity = 'Tỉnh/Thành Phố';
  String selectedDistrict = 'Quận/Huyện';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearchAndViewMode()), // 👈 đã thêm mới
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildFilterRow()),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildStoreCard(
                name: "KATINAT Đồng Khởi - Quận 1",
                address: "91 Đường Đồng Khởi, Quận 1, TP.HCM",
                open: "07:00",
                close: "22:30",
                imageUrl: "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
              ),
              _buildStoreCard(
                name: "KATINAT Crescent Residence 2",
                address: "107 Đường Tôn Dật Tiên, Quận 7, TP.HCM",
                open: "07:00",
                close: "22:30",
                imageUrl: "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
              ),
              _buildStoreCard(
                name: "KATINAT Biên Hòa - Đồng Khởi",
                address: "277 Đường Đồng Khởi, Biên Hòa, Đồng Nai",
                open: "07:00",
                close: "22:30",
                imageUrl: "https://images.unsplash.com/photo-1506084868230-bb9d95c24759",
              ),
            ]),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
  return ClipPath(
    clipper: SShapeClipper(),
    child: Container(
      padding: const EdgeInsets.only(top: 48, bottom: 40),
      color: Color(0xFF0F4C5C),
      width: double.infinity,
      child: Center(
        child: Text(
          "Nâu Coffee",
          style: GoogleFonts.bebasNeue(
            fontSize: 36,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    ),
  );
}

 Widget _buildSearchAndViewMode() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm cửa hàng...',
                prefixIcon: Icon(Icons.search, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
  children: List.generate(2, (index) {
    final isSelected = selectedViewIndex == index;
    final titles = ['Danh sách', 'Bản đồ'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            // 👉 Nếu là nút "Bản đồ", chuyển sang trang bản đồ
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreMapScreen()),
            );
          } else {
            // 👉 Nếu là "Danh sách" thì chỉ cập nhật giao diện
            setState(() {
              selectedViewIndex = index;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF0F4C5C) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            titles[index],
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }),
),

          ),
        ],
      ),
    ),
  );
}


  Widget _buildFilterRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Expanded(
          child: _buildDropdown(
            selectedCity,
            ["Tỉnh/Thành Phố", "Hồ Chí Minh", "Đồng Nai"],
            (String? val) {
              if (val != null) {
                setState(() => selectedCity = val);
              }
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildDropdown(
            selectedDistrict,
            ["Quận/Huyện", "Quận 1", "Quận 7", "Biên Hòa"],
            (String? val) {
              if (val != null) {
                setState(() => selectedDistrict = val);
              }
            },
          ),
        ),
        SizedBox(width: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.filter_alt_outlined, size: 18, color: Colors.black87),
            label: Text("Lọc", style: TextStyle(fontSize: 13, color: Colors.black87)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12),
              shape: StadiumBorder(),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        icon: Icon(Icons.arrow_drop_down),
        underline: SizedBox(),
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: Colors.black),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ),
    );
  }

  Widget _buildStoreCard({
    required String name,
    required String address,
    required String open,
    required String close,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(address, style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 4),
                  Text("Giờ mở cửa: $open  |  Giờ đóng cửa: $close", style: TextStyle(fontSize: 12)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.navigation),
                        label: Text("Chỉ đường"),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_bag),
                        label: Text("Đặt món"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF0F4C5C),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.local_cafe), label: 'Đặt nước'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Code'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Cửa hàng'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
      ],
      currentIndex: 3,
      onTap: (index) {},
    );
  }
}class SShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 40);

    path.cubicTo(
      size.width * 0.25, size.height + 20,
      size.width * 0.75, size.height - 100,
      size.width, size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
