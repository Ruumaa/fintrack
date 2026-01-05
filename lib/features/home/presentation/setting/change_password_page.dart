import 'package:fintrack/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/features/auth/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;

  void _handleUpdate() async {
    // 1. Validasi Input Dasar
    if (_oldPassController.text.isEmpty || _newPassController.text.isEmpty) {
      _showSnackBar("Semua kolom harus diisi", isError: true);
      return;
    }

    if (_newPassController.text.length < 6) {
      _showSnackBar("Kata sandi baru minimal 6 karakter", isError: true);
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      _showSnackBar("Konfirmasi kata sandi baru tidak cocok", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().changePassword(
        oldPassword: _oldPassController.text,
        newPassword: _newPassController.text,
      );

      if (mounted) {
        _showSnackBar("Kata sandi berhasil diperbarui!");
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      // Menangkap pesan error dari Supabase (misal: "Invalid login credentials")
      String errorMessage = e.toString();
      if (errorMessage.contains("Invalid login credentials")) {
        errorMessage = "Kata sandi lama yang Anda masukkan salah.";
      } else if (errorMessage.contains("Password should be")) {
        errorMessage = "Kata sandi terlalu lemah.";
      }

      _showSnackBar(errorMessage, isError: true);
    }
  }

  // Helper untuk menampilkan pesan
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keamanan Akun")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Placeholder Image/Illustration Area
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 80,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 30),

            _buildPassField(_oldPassController, "Kata Sandi Lama"),
            const SizedBox(height: 16),
            _buildPassField(_newPassController, "Kata Sandi Baru"),
            const SizedBox(height: 16),
            _buildPassField(
              _confirmPassController,
              "Konfirmasi Kata Sandi Baru",
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        "Simpan Kata Sandi",
                        style: TextStyle(color: Colors.white),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassField(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.lock_outline),
      ),
    );
  }
}
