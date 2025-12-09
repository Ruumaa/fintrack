import 'package:flutter/material.dart';

// Enum untuk membedakan jenis transaksi
enum TransactionType { income, expense }

class Transaction {
  final String id;
  final TransactionType type;
  final String category;
  final double amount;
  final String note;
  final DateTime date;
  final Color color;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
    required this.color,
  });

  // Helper untuk membuat salinan dengan perubahan (immutable data)
  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? category,
    double? amount,
    String? note,
    DateTime? date,
    Color? color,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      color: color ?? this.color,
    );
  }
}
