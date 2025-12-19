import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_color.dart';

class ChartCard extends StatelessWidget {
  final double totalExpense;

  const ChartCard({super.key, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: .3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Pengeluaran Hari Ini",
            style: TextStyle(fontSize: 16, color: AppColor.white),
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormat.format(totalExpense),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                const [0.8, 0.4, 0.6, 0.9].map((h) => _buildBar(h)).toList(),
          ),
        ],
      ),
    );
  }

  static Widget _buildBar(double heightFactor) {
    return Container(
      width: 10,
      height: 100 * heightFactor,
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
