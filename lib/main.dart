import 'package:fintrack/features/auth/presentation/login_page.dart';
import 'package:flutter/material.dart';
// Import AppTheme yang baru
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Menggunakan tema yang sudah didefinisikan
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}
