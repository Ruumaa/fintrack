import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    colorScheme: ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.secondary,
    ),
    scaffoldBackgroundColor: AppColor.background,

    // Gaya AppBar yang bersih dan rata
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // Menggunakan background scaffold
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColor.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColor.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Gaya Input Field yang modern (Filled, Borderless, Rounded)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.white, // Latar belakang putih untuk bidang input
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColor.textSecondary, fontSize: 14),
      labelStyle: const TextStyle(color: AppColor.textSecondary),
      errorStyle: const TextStyle(fontSize: 12, color: AppColor.error),
      prefixIconColor: AppColor.textSecondary,
    ),

    // Gaya Tombol Utama (Primary Button Style)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColor.white,
        backgroundColor: AppColor.primary,
        minimumSize: const Size(
          double.infinity,
          52,
        ), // Tombol sedikit lebih tinggi
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        elevation: 2, // Tambahkan sedikit bayangan
      ),
    ),

    // Gaya Tombol Teks
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
