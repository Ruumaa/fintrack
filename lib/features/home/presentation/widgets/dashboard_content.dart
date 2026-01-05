import 'package:fintrack/models/transaction.dart';
import 'package:flutter/material.dart';
import 'chart_card.dart';
import 'transaction_item_tile.dart';
import '../../../../core/theme/app_color.dart';

class DashboardContent extends StatelessWidget {
  final List<Transaction> transactions;
  final String userEmail;
  final String? username;

  const DashboardContent({
    super.key,
    required this.transactions,
    required this.userEmail,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan username jika ada, jika tidak gunakan fallback email
    String displayName;
    if (username != null && username!.isNotEmpty) {
      displayName = username!;
    } else {
      final rawName =
          userEmail.contains('@') ? userEmail.split('@')[0] : userEmail;
      displayName = rawName[0].toUpperCase() + rawName.substring(1);
    }

    final today = DateTime.now();

    // Logika filtering
    final dailyTransactions =
        transactions
            .where(
              (t) =>
                  t.date.year == today.year &&
                  t.date.month == today.month &&
                  t.date.day == today.day,
            )
            .toList();

    final totalExpense = dailyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, $displayName",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Pantau pengeluaran Anda hari ini.",
            style: TextStyle(color: AppColor.textSecondary),
          ),
          const SizedBox(height: 24),
          ChartCard(totalExpense: totalExpense),
          const SizedBox(height: 32),
          const Text(
            "Riwayat Transaksi Hari Ini",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (dailyTransactions.isEmpty)
            const Center(child: Text("Belum ada transaksi hari ini."))
          else
            ...dailyTransactions.map(
              (t) => TransactionItemTile(transaction: t),
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
