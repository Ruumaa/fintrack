import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparan dengan tombol kembali
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: AppColor.background,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Judul dan Subjudul
              const Text(
                "Create Account ✨",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Daftar untuk memulai mengelola keuangan",
                style: TextStyle(fontSize: 16, color: AppColor.textSecondary),
              ),

              const SizedBox(height: 32),

              // Input Username
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Input Password
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Input Confirm Password
              TextField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                ),
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 30),

              // Tombol Register (menggunakan ElevatedButtonTheme)
              ElevatedButton(
                onPressed: () {
                  // TODO: implement API register & validation
                },
                child: const Text("Register"),
              ),

              const SizedBox(height: 24),

              // Prompt Login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: TextStyle(color: AppColor.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        // Kembali ke halaman sebelumnya (Login Page)
                        Navigator.pop(context);
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
