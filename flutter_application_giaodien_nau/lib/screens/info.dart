import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/screens/ChangePasswordScreen.dart';
import 'package:flutter_application_giaodien_nau/screens/edit_profile_screen.dart';
import 'package:flutter_application_giaodien_nau/screens/theme_provider.dart';
import 'package:flutter_application_giaodien_nau/services/api_auth.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const UserProfileScreen({super.key, required this.userData});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.userData);
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final email = _data['email'];
      if (email == null || email.toString().trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy email người dùng')),
        );
        return;
      }

      final updatedUser = await ApiAuth.uploadAvatar(picked, email);

      if (updatedUser != null) {
        setState(() {
          _data = updatedUser;
          _data['anhDaiDien'] =
              '${_data['anhDaiDien']}?ts=${DateTime.now().millisecondsSinceEpoch}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật ảnh thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi tải ảnh lên')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String hoTen = (_data['hoTen'] ?? '').trim().isEmpty
        ? 'Chưa cập nhật'
        : _data['hoTen'];
    final String email = (_data['email'] ?? '').trim().isEmpty
        ? 'Chưa cập nhật'
        : _data['email'];

    final List<String?> phoneCandidates = [
      _data['soDienThoai'],
      _data['phone'],
      _data['sdt'],
      _data['phoneNumber'],
      _data['contact']?['mobile'],
      _data['thongTinLienHe']?['soDienThoai'],
    ];

    final String soDienThoai = phoneCandidates.firstWhere(
          (e) => e != null && e.trim().isNotEmpty,
          orElse: () => null,
        )?.trim() ??
        'Chưa cập nhật';

    final String? avatarUrl = _data['anhDaiDien'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'NÂU COFFEE',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Coffee and Tea',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00425A),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            key: UniqueKey(),
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl == null || avatarUrl.isEmpty
                                ? const Icon(Icons.person, size: 30, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 20, color: Colors.blue),
                              onPressed: _pickAndUploadAvatar,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hoTen,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(email, style: const TextStyle(color: Colors.grey)),
                            Text(soDienThoai, style: const TextStyle(color: Colors.grey)), 
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xfff1f0fb),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEW MEMBER',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                        SizedBox(height: 8),
                        Text('0 KAT (KAT khả dụng)', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  AccountItem(icon: Icons.edit, label: 'Chỉnh sửa'),
                  AccountItem(icon: Icons.local_cafe, label: 'Sở thích'),
                  AccountItem(icon: Icons.favorite_border, label: 'Yêu thích'),
                  AccountItem(icon: Icons.emoji_events, label: 'Đặc quyền'),
                  AccountItem(icon: Icons.discount, label: 'Ưu đãi'),
                  AccountItem(icon: Icons.history, label: 'Lịch sử'),
                  AccountItem(icon: Icons.reviews, label: 'Đánh giá'),
                  AccountItem(icon: Icons.group_add, label: 'Giới thiệu'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // OPTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  AccountOption(icon: Icons.lock, label: 'Đổi mật khẩu', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChangePasswordScreen(email: email)),
                    );
                  }),
                  AccountOption(icon: Icons.edit, label: 'Chỉnh sửa thông tin', onTap: () async {
                    final updated = await Navigator.push<Map<String, String>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(userData: _data),
                      ),
                    );
                    if (updated != null) {
                      setState(() {
                        _data['hoTen'] = updated['hoTen'];
                        _data['email'] = updated['email'];
                        _data['soDienThoai'] = updated['soDienThoai'];
                      });
                 
                    }
                  }),
                  AccountOption(icon: Icons.logout, label: 'Đăng xuất', onTap: () async {
                    final success = await ApiAuth.logout();
                    if (success && mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đăng xuất thất bại')),
                      );
                    }
                  }),
                  AccountOption(
  icon: Icons.dark_mode,
  label: 'Chế độ tối',
  onTap: () {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    themeProvider.toggleTheme(!isDark);
  },
),

                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Phiên bản: 1.0.38', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// === Widgets phụ trợ ===
class AccountItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const AccountItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigo, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }
}

class AccountOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AccountOption({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(icon, color: Colors.indigo),
          title: Text(label, style: const TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
