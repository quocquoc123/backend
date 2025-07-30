import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/services/api_auth.dart';


class ChangePasswordScreen extends StatefulWidget {
  final String email;
  const ChangePasswordScreen({super.key, required this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldCtl = TextEditingController();
  final _newCtl = TextEditingController();
  bool _saving = false;

  Future<void> _submit() async {
    if (_newCtl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu mới phải ≥ 6 ký tự'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final ok = await ApiAuth.changePasswordPublic(
      email: widget.email,
      matKhauCu: _oldCtl.text,
      matKhauMoi: _newCtl.text,
    );

    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? '✅ Đổi mật khẩu thành công' : '❌ Mật khẩu cũ không đúng'),
        backgroundColor: ok ? Colors.green : Colors.redAccent,
      ),
    );

    if (ok) Navigator.pop(context);
  }

  @override
  void dispose() {
    _oldCtl.dispose();
    _newCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟦 Icon minh họa to ở đầu
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.lock_person_rounded,
                    size: 100,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cập nhật mật khẩu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy đặt mật khẩu mạnh hơn để bảo vệ tài khoản của bạn.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: _oldCtl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _newCtl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới (≥ 6 ký tự)',
                prefixIcon: const Icon(Icons.lock_reset),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _submit,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _saving
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check, key: ValueKey('icon')),
                ),
                label: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
