import 'package:fintrack/features/home/presentation/create_transaction_page.dart';
import 'package:fintrack/features/home/presentation/settings_page.dart';
import 'package:fintrack/models/transaction_category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_color.dart';
import '../../../models/transaction.dart'; // Import model Transaction

// --- DashboardContent (Menampilkan Data) ---
// Jadikan widget ini menerima daftar transaksi
class DashboardContent extends StatelessWidget {
  // Terima daftar transaksi sebagai parameter
  final List<Transaction> transactions;

  const DashboardContent({super.key, required this.transactions});

  // Helper untuk memformat mata uang Rupiah
  String _formatRupiah(double amount) {
    // Menggunakan intl package untuk format yang lebih baik
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Menghitung Total Pengeluaran Hari Ini (Mock data dihilangkan)
  double get _totalDailyExpense {
    // Filter transaksi hari ini dan hanya yang bertipe expense
    final today = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day,
        )
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Mendapatkan Riwayat Transaksi Hari Ini
  List<Transaction> get _dailyHistory {
    final today = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.date.year == today.year &&
              t.date.month == today.month &&
              t.date.day == today.day,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Urutkan dari yang terbaru
  }

  // Mock data untuk Bar Chart Placeholder (Bisa disimpan di sini atau dihapus)
  final List<double> mockChartData = const [0.8, 0.4, 0.6, 0.9];

  // Widget untuk membuat tampilan Card Bar Chart
  Widget _buildChartCard(BuildContext context) {
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatRupiah(_totalDailyExpense), // Menggunakan data real
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColor.white,
            ),
          ),
          const SizedBox(height: 20),

          // Placeholder Bar Charts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                mockChartData.map((heightFactor) {
                  return _buildBar(context, heightFactor);
                }).toList(),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ... label bar chart
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Bar Chart Bar
  Widget _buildBar(BuildContext context, double heightFactor) {
    return Container(
      width: 10,
      height: 100 * heightFactor,
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Helper Widget untuk setiap item transaksi
  Widget _buildTransactionItem(Transaction transaction) {
    final String formattedAmount = _formatRupiah(transaction.amount);
    final isExpense = transaction.type == TransactionType.expense;
    final displayColor = isExpense ? AppColor.error : AppColor.secondary;

    // Mengambil ikon berdasarkan nama kategori (harus disesuaikan dengan data mock kategori)
    IconData icon = Icons.attach_money_rounded;
    if (isExpense) {
      final category = expenseCategories.firstWhere(
        (cat) => cat.name == transaction.category,
        orElse: () => expenseCategories.first, // Fallback
      );
      icon = category.icon;
    } else {
      final category = incomeCategories.firstWhere(
        (cat) => cat.name == transaction.category,
        orElse: () => incomeCategories.first, // Fallback
      );
      icon = category.icon;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon Kategori
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: transaction.color, size: 20),
          ),
          const SizedBox(width: 16),

          // Nama Kategori dan Catatan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textPrimary,
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

          // Nilai Transaksi
          Text(
            (isExpense ? '- ' : '+ ') +
                formattedAmount.substring(3), // Hapus 'Rp ' dari string
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: displayColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String username = "Fintrack User";
    final dailyHistory = _dailyHistory; // Ambil riwayat harian

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. Greeting Section ---
          Text(
            "Hello, $username",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Pantau pengeluaran Anda hari ini, ${DateFormat('EEEE, d MMMM').format(DateTime.now())}.",
            style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
          ),

          const SizedBox(height: 24),

          // --- 2. Card with Bar Charts Placeholder ---
          _buildChartCard(context),

          const SizedBox(height: 32),

          // --- 3. Expense History Header ---
          const Text(
            "Riwayat Transaksi Hari Ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // --- 4. Expense History List ---
          if (dailyHistory.isEmpty)
            const Center(
              child: Text(
                "Belum ada transaksi hari ini.",
                style: TextStyle(color: AppColor.textSecondary),
              ),
            )
          else
            ...dailyHistory.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildTransactionItem(transaction),
              );
            }).toList(),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// --- HomePage (Mengelola State dan Navigasi) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // State untuk menyimpan daftar transaksi
  final List<Transaction> _transactions = [
    // Tambahkan beberapa mock data awal
    Transaction(
      id: 't1',
      type: TransactionType.expense,
      category: 'Makanan & Minuman',
      amount: 50000.0,
      note: 'Makan siang di kantor',
      date: DateTime.now(),
      color: Colors.orange,
    ),
    Transaction(
      id: 't2',
      type: TransactionType.income,
      category: 'Gaji Bulanan',
      amount: 5000000.0,
      note: 'Gaji bulan ini',
      date: DateTime.now().subtract(const Duration(days: 1)),
      color: AppColor.secondary,
    ),
    Transaction(
      id: 't3',
      type: TransactionType.expense,
      category: 'Transportasi',
      amount: 25000.0,
      note: 'Tiket bus',
      date: DateTime.now(),
      color: Colors.blue,
    ),
  ];

  void _addTransaction(Transaction newTransaction) {
    setState(() {
      _transactions.add(newTransaction);
      // Pindah kembali ke halaman Home setelah menambah transaksi
      _currentIndex = 0;
    });
  }

  // Daftar halaman disesuaikan untuk meneruskan data/callback
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // Indeks 0: Dashboard/Home Content - Menerima data transaksi
      DashboardContent(transactions: _transactions),
      // Indeks 1: Halaman Create Transaksi - Menerima callback untuk menambah data
      CreatePage(onAddTransaction: _addTransaction),
      // Indeks 2: Halaman User Setting
      const SettingsPage(),
    ];
  }

  // Perlu memperbarui _pages di build/didUpdateWidget jika ingin dinamis,
  // atau cukup buat ulang listnya di sini dan panggil _onTabTapped
  void _onTabTapped(int index) {
    if (index == 1) {
      // Saat pindah ke halaman Create, buat ulang CreatePage agar form bersih
      setState(() {
        _currentIndex = index;
        _pages[1] = CreatePage(onAddTransaction: _addTransaction);
      });
    } else {
      // Saat pindah ke halaman Home, buat ulang DashboardContent dengan data terbaru
      if (index == 0) {
        _pages[0] = DashboardContent(transactions: _transactions);
      }
      setState(() {
        _currentIndex = index;
      });
    }
  }

  final List<String> _titles = const [
    "Dashboard",
    "Buat Transaksi",
    "Pengaturan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppColor.textPrimary,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Konten halaman yang ditampilkan
      // Gunakan PageView.builder agar bisa di-swipe, namun untuk BottomNavBar,
      // menggunakan list widget biasa sudah cukup
      body: _pages[_currentIndex],

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: AppColor.white,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: AppColor.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_rounded, size: 32),
              label: 'Buat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
