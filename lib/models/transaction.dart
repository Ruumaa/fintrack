import 'package:flutter/material.dart';

// Enum untuk membedakan jenis transaksi
enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final String category;
  final double amount;
  final String note;
  final DateTime date;
  final Color color;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
    required this.color,
  });

  // Konversi dari Map (Database) ke Object (Flutter)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type:
          map['type'] == 'income'
              ? TransactionType.income
              : TransactionType.expense,
      category: map['category'] ?? 'Lain-lain',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      note: map['note'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      // Pastikan ini tidak null
      color: map['color'] != null ? Color(map['color'] as int) : Colors.blue,
    );
  }

  // Konversi dari Object (Flutter) ke Map (Database)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'category': category,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
      'color': color.value,
    };
  }
}
