import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_giaodien_nau/models/app_theme.dart';
import 'package:flutter_application_giaodien_nau/screens/homescreen.dart';
import 'package:flutter_application_giaodien_nau/screens/info.dart';
import 'package:flutter_application_giaodien_nau/screens/login_screen.dart';
import 'package:flutter_application_giaodien_nau/screens/theme_provider.dart';
import 'package:flutter_application_giaodien_nau/services/ProductProvider.dart';
import 'package:provider/provider.dart';

import 'my_http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()), // Thêm Provider cho ProductProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Ứng dụng Cà Phê',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        // Thêm route cho MyHomePage nếu cần
        // '/home': (context) => MyHomePage(userData: {}), // Ví dụ
      },
    );
  }
}