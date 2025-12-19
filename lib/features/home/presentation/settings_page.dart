import 'package:fintrack/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  // void _handleLogout(BuildContext context) {
  //   // Implementasi logika logout dan navigasi kembali ke LoginPage
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Anda telah Logout')),
  //   );
  // }

  // get authservice
  final authService = AuthService();

  // logout function
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Pengaturan Akun",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // --- Bagian Umum ---
          _buildSettingsHeader("Umum"),
          _buildSettingItem(
            icon: Icons.person_outline_rounded,
            title: "Edit Profil",
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.lock_outline_rounded,
            title: "Ubah Kata Sandi",
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.notifications_none_rounded,
            title: "Notifikasi",
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // --- Bagian Aplikasi ---
          _buildSettingsHeader("Aplikasi"),
          _buildSettingItem(
            icon: Icons.info_outline_rounded,
            title: "Tentang Aplikasi",
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.star_outline_rounded,
            title: "Beri Rating",
            onTap: () {},
          ),

          const SizedBox(height: 40),

          // --- Tombol Logout (Warna Merah untuk Aksi Penting) ---
          ElevatedButton.icon(
            // onPressed: () => _handleLogout(context),
            onPressed: logout,
            icon: const Icon(Icons.logout_rounded, color: AppColor.white),
            label: const Text(
              "Logout",
              style: TextStyle(color: AppColor.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error, // Warna merah untuk logout
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper Widget untuk judul bagian pengaturan
  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColor.textSecondary,
        ),
      ),
    );
  }

  // Helper Widget untuk setiap item pengaturan
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: AppColor.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColor.textSecondary,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        tileColor: AppColor.white,
      ),
    );
  }
}
