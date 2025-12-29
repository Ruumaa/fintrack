import 'package:fintrack/features/auth/auth_service.dart';
import 'package:fintrack/features/home/service/transaction_service.dart';
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
  final transactionService = TransactionService();
  int _currentIndex = 0;

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaction>>(
      stream: transactionService.getTransactionsStream(),
      builder: (context, snapshot) {
        // Tangani jika terjadi error pada Stream
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Terjadi kesalahan: ${snapshot.error}")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ambil data
        final transactions = snapshot.data ?? [];
        final currentEmail = AuthService().getCurrentUserEmail() ?? "User";

        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting &&
            transactions.isEmpty) {
          body = const Center(child: CircularProgressIndicator());
        } else {
          switch (_currentIndex) {
            case 0:
              body = DashboardContent(
                transactions: transactions,
                userEmail: currentEmail,
              );
              break;
            case 1:
              body = CreatePage(
                onAddTransaction: (t) async {
                  await transactionService.saveTransaction(t);
                  if (mounted) setState(() => _currentIndex = 0);
                },
              );
              break;
            case 2:
              body = SettingsPage();
              break;
            default:
              body = const SizedBox();
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(["Dashboard", "Buat", "Setting"][_currentIndex]),
          ),
          body: body,
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }
}
