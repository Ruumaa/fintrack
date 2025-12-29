import 'package:fintrack/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import '../../../../models/transaction.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType selectedType;
  final Function(TransactionType) onSelected;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(
          label: 'Pengeluaran 💸',
          type: TransactionType.expense,
          activeColor: AppColor.error.withValues(alpha: .1),
        ),
        const SizedBox(width: 10),
        _buildChip(
          label: 'Pemasukan 💰',
          type: TransactionType.income,
          activeColor: AppColor.secondary,
        ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required TransactionType type,
    required Color activeColor,
  }) {
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        selected: selectedType == type,
        selectedColor: activeColor,
        onSelected: (selected) => selected ? onSelected(type) : null,
      ),
    );
  }
}
