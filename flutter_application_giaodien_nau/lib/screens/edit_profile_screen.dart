import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/services/api_auth.dart';


class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _nameCtl = TextEditingController(text: widget.userData['hoTen'] ?? '');
  late final _mailCtl = TextEditingController(text: widget.userData['email'] ?? '');
  late final _phoneCtl = TextEditingController(text: widget.userData['soDienThoai'] ?? '');
  final _pwdCtl = TextEditingController();

  bool _saving = false;

  Future<void> _save() async {
    if (_pwdCtl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mật khẩu hiện tại'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final ok = await ApiAuth.updateProfilePublic(
      email: _mailCtl.text.trim(),
      matKhauCu: _pwdCtl.text,
      hoTen: _nameCtl.text.trim(),
      soDienThoai: _phoneCtl.text.trim(),
    );

    setState(() => _saving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Cập nhật thành công"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop<Map<String, String>>(context, {
        'hoTen': _nameCtl.text.trim(),
        'email': _mailCtl.text.trim(),
        'soDienThoai': _phoneCtl.text.trim(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Cập nhật thất bại"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _mailCtl.dispose();
    _phoneCtl.dispose();
    _pwdCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Icon minh họa
            Icon(Icons.edit_note_rounded, size: 100, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            const Text(
              "Cập nhật thông tin cá nhân",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Điền thông tin mới và xác nhận bằng mật khẩu hiện tại.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            _buildTextField(_nameCtl, "Họ tên", Icons.person),
            const SizedBox(height: 16),
            _buildTextField(_mailCtl, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(_phoneCtl, "Số điện thoại", Icons.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_pwdCtl, "Mật khẩu hiện tại", Icons.lock, obscureText: true),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: theme.colorScheme.primary,
                ),
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.grey[100],
      ),
    );
  }
}
