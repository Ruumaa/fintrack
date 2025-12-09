import 'package:flutter/material.dart';
import '../core/theme/app_color.dart';

class TransactionCategory {
  final String name;
  final IconData icon;
  final Color color;

  TransactionCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Data mock untuk Kategori Pemasukan
final List<TransactionCategory> incomeCategories = [
  TransactionCategory(
    name: 'Gaji Bulanan',
    icon: Icons.attach_money_rounded,
    color: AppColor.secondary,
  ),
  TransactionCategory(
    name: 'Bonus',
    icon: Icons.star_rounded,
    color: Colors.amber,
  ),
  TransactionCategory(
    name: 'Hadiah',
    icon: Icons.card_giftcard_rounded,
    color: Colors.pink,
  ),
  TransactionCategory(
    name: 'Lain-lain',
    icon: Icons.more_horiz_rounded,
    color: Colors.blueGrey,
  ),
];

// Data mock untuk Kategori Pengeluaran
final List<TransactionCategory> expenseCategories = [
  TransactionCategory(
    name: 'Makanan & Minuman',
    icon: Icons.fastfood_rounded,
    color: Colors.orange,
  ),
  TransactionCategory(
    name: 'Transportasi',
    icon: Icons.directions_bus_rounded,
    color: Colors.blue,
  ),
  TransactionCategory(
    name: 'Belanja',
    icon: Icons.shopping_bag_rounded,
    color: Colors.pinkAccent,
  ),
  TransactionCategory(
    name: 'Hiburan',
    icon: Icons.movie_rounded,
    color: Colors.purple,
  ),
  TransactionCategory(
    name: 'Tagihan',
    icon: Icons.receipt_rounded,
    color: Colors.redAccent,
  ),
  TransactionCategory(
    name: 'Lain-lain',
    icon: Icons.more_horiz_rounded,
    color: Colors.blueGrey,
  ),
];
