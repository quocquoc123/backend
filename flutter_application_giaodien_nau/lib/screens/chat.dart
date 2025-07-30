import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrenyChatbotScreen extends StatefulWidget {
  const PrenyChatbotScreen({super.key});

  @override
  State<PrenyChatbotScreen> createState() => _PrenyChatbotScreenState();
}

class _PrenyChatbotScreenState extends State<PrenyChatbotScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://app.preny.ai/embed/687e7d4fc6a004caf574d3b6'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat với Preny')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
