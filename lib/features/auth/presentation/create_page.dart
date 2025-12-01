import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add_rounded, color: AppColor.secondary, size: 80),
            SizedBox(height: 20),
            Text(
              "Halaman Pembuatan Transaksi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Di sini akan ada form untuk mencatat Pemasukan atau Pengeluaran baru.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColor.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
