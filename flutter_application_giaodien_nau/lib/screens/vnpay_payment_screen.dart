import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/screens/homescreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const VNPayPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<VNPayPaymentScreen> createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  late final WebViewController _controller;
@override
void initState() {
  super.initState();

  // _controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..loadRequest(Uri.parse(widget.paymentUrl));

  // print("VNPay URL: ${widget.paymentUrl}");
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          // 👇 Kiểm tra nếu URL là scheme để quay về app
          if (request.url.startsWith('naucoffee://payment-success')) {
  Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MyHomePage(userData: {},)),
                (route) => false,
              );            return NavigationDecision.prevent; // chặn không mở tiếp trong WebView
          }
          return NavigationDecision.navigate; // cho phép mở URL bình thường
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.paymentUrl));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán VNPay')),
      body: WebViewWidget(controller: _controller),
      
    );
  }
}
