import 'package:fintrack/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import '../../../core/theme/app_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // get auth srevice
  final authService = AuthService();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login button pressed
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // attempt login..
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Username atau password salah";
        });
      }
    }
  }

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder Gambar/Logo
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColor.primary,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Judul dan Subjudul
              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Kelola keuanganmu dengan mudah",
                style: TextStyle(fontSize: 16, color: AppColor.textSecondary),
              ),

              const SizedBox(height: 32),
              // Input Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Input Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              // Pesan Error
              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: AppColor.error, fontSize: 14),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // Tombol Login (menggunakan ElevatedButtonTheme)
              ElevatedButton(onPressed: login, child: const Text("Login")),

              const SizedBox(height: 16),

              // Divider "ATAU"
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColor.textSecondary, height: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "ATAU",
                      style: TextStyle(
                        color: AppColor.textSecondary.withValues(alpha: .6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColor.textSecondary, height: 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tombol Google Login (Outlined Button)
              OutlinedButton(
                onPressed: () {
                  // nanti diisi untuk Google login
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Menggunakan placeholder ikon Google
                    Image.asset(
                      "assets/images/google-logo.png",
                      height: 24,
                      errorBuilder:
                          (context, error, stackTrace) => const Text(
                            'G',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Login with Google",
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Prompt Register
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: TextStyle(color: AppColor.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        // Menggunakan push untuk navigasi ke halaman Register
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text("Daftar di sini"),
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
