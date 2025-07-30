import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/screens/admin_screens/admin_home.dart';
import 'package:flutter_application_giaodien_nau/services/api_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'homescreen.dart';
import 'forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _isButtonPressed = false;

  late AnimationController _animationController;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();
    
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);

    _color1 = ColorTween(begin: const Color(0xFF0F4C5C), end: const Color(0xFF0F4C5C))
        .animate(_animationController);
    _color2 = ColorTween(begin: const Color(0xFFEFF6F7), end: const Color(0xFFEFF6F7))
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _password.dispose();
    super.dispose();
  }

 void _login() async {
  var result = await ApiAuth.login(
    email: _emailController.text,
    matKhau: _password.text,
  );

  print("🔥 Kết quả trả về từ API: $result");

  if (result != null) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final otpController = TextEditingController();
        bool isVerifying = false;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "🔐 Xác thực OTP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Vui lòng nhập mã OTP đã gửi đến email của bạn",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Mã OTP",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () async {
                        setStateModal(() => isVerifying = true);

                        // ✅ Gửi OTP xác thực đăng nhập (POST /xac-thuc-dang-nhap)
                        final info = await ApiAuth.verifyLoginOTP(
                          email: _emailController.text,
                          
                          selectedOtp: otpController.text.trim(),
                            
                        );
                        
                        print('🔥 userData: $info'); // 🔍 Xem toàn bộ dữ liệu người dùng từ API
 
                        setStateModal(() => isVerifying = false);
if (info != null) {
  Navigator.pop(context); // đóng OTP modal

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', info['id']); // ✅ Lưu userId vào local

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("✅ Đăng nhập thành công!"),
      backgroundColor: Colors.green,
    ),
  );

  if (info['vaiTro'] == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
        builder: (_) => MyHomePage(userData: info)
// <-- truyền userData
      ),
    );
  }
} 

 else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("❌ OTP không đúng hoặc đã hết hạn."),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F4C5C), Color(0xFF002C40)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: isVerifying
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Xác thực",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Huỷ",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("❌ Sai email hoặc mật khẩu."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}



  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.05),
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      onEnd: () => setState(() {}),
      child: const Icon(
        Icons.local_cafe_rounded,
        size: 90,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.white70,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_showPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      cursorColor: const Color(0xFF0F4C5C),
      style: GoogleFonts.poppins(color: const Color(0xFF0F4C5C), fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF0F4C5C)),
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF0F4C5C), fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: const Color(0xFFE7F0F2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0F4C5C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0F4C5C), width: 2),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF0F4C5C),
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isButtonPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isButtonPressed = false);
        _login();
      },
      onTapCancel: () {
        setState(() => _isButtonPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _isButtonPressed
                ? [Colors.blue.shade900, Colors.blue.shade700]
                : [const Color(0xFF0F4C5C), Colors.blue.shade900],
          ),
          boxShadow: _isButtonPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 6),
                    blurRadius: 8,
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          "ĐĂNG NHẬP",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_color1.value ?? const Color(0xFF0F4C5C), _color2.value ?? const Color(0xFFEFF6F7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 12),
                  Text(
                    "Coffee App",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField("Email", _emailController, Icons.email),
                        const SizedBox(height: 16),
                        _buildTextField("Mật khẩu", _password, Icons.lock, isPassword: true),
                        const SizedBox(height: 12),
                        _buildLoginButton(),
                        const SizedBox(height: 20),
                      Wrap(
  alignment: WrapAlignment.center,
  spacing: 10,
  runSpacing: 8,
  children: [
    const Text(
      "Chưa có tài khoản? ",
      style: TextStyle(color: Color(0xFF0F4C5C), fontSize: 14),
    ),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const Text(
        "Đăng ký",
        style: TextStyle(
          color: Color(0xFF0F4C5C),
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    ),
    const Text("|", style: TextStyle(color: Colors.grey, fontSize: 14)),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
        );
      },
      child: const Text(
        "Quên mật khẩu?",
        style: TextStyle(
          color: Color(0xFF0F4C5C),
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  ],
),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "© Coffee App 2025",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
