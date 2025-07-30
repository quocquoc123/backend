import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/services/api_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;

  void _sendOTP() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final success = await ApiAuth.sendOTP(email);
    if (success) {
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã gửi OTP đến email")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gửi OTP thất bại")));
    }
  }

  void _verifyOTP() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    if (otp.isEmpty) return;

    final success = await ApiAuth.verifyOTP(email, otp);
    if (success) {
      setState(() => _otpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Xác thực OTP thành công")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mã OTP không hợp lệ")));
    }
  }

  void _resetPassword() async {
    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    if (newPassword.isEmpty) return;

    final success = await ApiAuth.resetPassword(email, newPassword);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đặt lại mật khẩu thành công")));
      Navigator.pop(context); // quay lại màn hình login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thất bại khi đặt lại mật khẩu")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            if (!_otpSent)
              ElevatedButton(onPressed: _sendOTP, child: const Text("Gửi OTP")),
            if (_otpSent && !_otpVerified) ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: "Nhập mã OTP"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _verifyOTP, child: const Text("Xác thực OTP")),
            ],
            if (_otpVerified) ...[
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: "Mật khẩu mới"),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _resetPassword, child: const Text("Đặt lại mật khẩu")),
            ]
          ],
        ),
      ),
    );
  }
}
