import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar menggunakan tema default dengan warna primary
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan ikon dan warna sekunder untuk kesan cerah
              Icon(
                Icons.check_circle_outline,
                color: AppColor.secondary,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to Your Finance App 🎯",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Aplikasi ini kini tampil lebih modern dan rapi!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColor.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
