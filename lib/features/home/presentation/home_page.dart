import 'package:fintrack/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'widgets/dashboard_content.dart';
import 'create_transaction_page.dart';
import 'settings_page.dart';
import '../../../models/transaction.dart';
import '../../../core/theme/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get auth service
  final authService = AuthService();

  int _currentIndex = 0;
  final List<Transaction> _transactions = [];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    // get user email
    final currentEmail = authService.getCurrentUserEmail() ?? "User";

    final List<Widget> pages = [
      DashboardContent(transactions: _transactions, userEmail: currentEmail),
      CreatePage(
        onAddTransaction:
            (t) => setState(() {
              _transactions.add(t);
              _currentIndex = 0;
            }),
      ),
      SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ["Dashboard", "Buat Transaksi", "Pengaturan"][_currentIndex],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      selectedItemColor: AppColor.primary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_rounded, size: 32),
          label: 'Buat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Setting',
        ),
      ],
    );
  }
}
