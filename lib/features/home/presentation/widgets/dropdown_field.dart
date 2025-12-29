import 'package:flutter/material.dart';
import 'package:fintrack/models/transaction_category.dart';

class CategoryDropdownField extends StatelessWidget {
  final TransactionCategory value;
  final List<TransactionCategory> items;
  final ValueChanged<TransactionCategory?> onChanged;

  const CategoryDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TransactionCategory>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items:
          items.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(category.icon, color: category.color),
                  const SizedBox(width: 10),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }
}
