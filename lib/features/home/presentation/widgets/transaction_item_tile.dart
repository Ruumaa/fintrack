import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/transaction.dart';
import '../../../../core/theme/app_color.dart';

class TransactionItemTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildCategoryIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  transaction.note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${isExpense ? '-' : '+'} ${currencyFormat.format(transaction.amount).substring(3)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isExpense ? AppColor.error : AppColor.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: transaction.color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.receipt_long, color: transaction.color, size: 20),
    );
  }
}
