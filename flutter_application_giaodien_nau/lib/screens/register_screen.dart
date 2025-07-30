import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/services/api_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();

  void _register() async {
    try {
      bool success = await ApiAuth.register(
        tenDangNhap: _phoneController.text,       // Sử dụng số điện thoại làm tên đăng nhập
        matKhau: _passwordController.text,
        hoTen: _fullnameController.text,
        email: _emailController.text,
        // Có thể bổ sung thêm: soDienThoai: _phoneController.text,
      );

    if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Đăng ký thành công!")),
  );
  Navigator.pop(context);
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Đăng ký thất bại.")),
  );
}

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  void _goToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F4C5C),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: const Icon(Icons.coffee_rounded, size: 90, color: Colors.white),
              ),
              const SizedBox(height: 18),
              Text(
                "Coffee App",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.1,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField("Số điện thoại", _phoneController, Icons.phone),
                    const SizedBox(height: 20),
                    _buildTextField("Mật khẩu", _passwordController, Icons.lock, isPassword: true),
                    const SizedBox(height: 20),
                    _buildTextField("Họ tên", _fullnameController, Icons.badge),
                    const SizedBox(height: 20),
                    _buildTextField("Email", _emailController, Icons.email),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4C5C),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black54,
                        ),
                        child: Text(
                          "ĐĂNG KÝ",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _goToLogin,
                      child: Text(
                        "Đã có tài khoản? Đăng nhập",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0F4C5C),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "© Coffee App 2025",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF0F4C5C)),
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF0F4C5C)),
        filled: true,
        fillColor: const Color(0xFFE7F0F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0F4C5C), width: 2),
        ),
      ),
      keyboardType: label == "Số điện thoại" ? TextInputType.phone : null,
      cursorColor: const Color(0xFF0F4C5C),
    );
  }
}
