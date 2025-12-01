import 'package:fintrack/features/auth/presentation/create_page.dart';
import 'package:fintrack/features/auth/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

// Import halaman utama dashboard yang akan menjadi konten indeks 0
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  // Mock data untuk Bar Chart Placeholder
  final List<double> mockChartData = const [0.8, 0.4, 0.6, 0.9];

  // Mock data untuk Riwayat Pengeluaran
  final List<Map<String, dynamic>> mockExpenses = const [
    {
      'category': 'Makanan & Minuman',
      'icon': Icons.fastfood_rounded,
      'color': Colors.orange,
      'amount': 50000.0,
    },
    {
      'category': 'Transportasi',
      'icon': Icons.directions_bus_rounded,
      'color': Colors.blue,
      'amount': 25000.0,
    },
    {
      'category': 'Belanja',
      'icon': Icons.shopping_bag_rounded,
      'color': Colors.pinkAccent,
      'amount': 120000.0,
    },
  ];

  // Widget untuk membuat tampilan Card Bar Chart
  Widget _buildChartCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.primary, // Menggunakan warna primer untuk kartu utama
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Pengeluaran Bulan Ini",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Rp 1.540.000",
            style: TextStyle(
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
              Text(
                'Min 1',
                style: TextStyle(color: AppColor.white, fontSize: 10),
              ),
              Text(
                'Min 2',
                style: TextStyle(color: AppColor.white, fontSize: 10),
              ),
              Text(
                'Min 3',
                style: TextStyle(color: AppColor.white, fontSize: 10),
              ),
              Text(
                'Min 4',
                style: TextStyle(color: AppColor.white, fontSize: 10),
              ),
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
      height: 100 * heightFactor, // Tinggi bar maksimum 100
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Helper Widget untuk setiap item pengeluaran
  Widget _buildExpenseItem({
    required IconData icon,
    required String category,
    required double amount,
    required Color color,
  }) {
    // Format mata uang Rupiah (Indonesia)
    final String formattedAmount =
        'Rp ${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),

          // Nama Kategori
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColor.textPrimary,
              ),
            ),
          ),

          // Nilai Pengeluaran
          Text(
            formattedAmount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.error, // Warna merah/error untuk pengeluaran
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder untuk nama pengguna
    const String username = "Fintrack User";

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
            "Pantau pengeluaran Anda hari ini.",
            style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
          ),

          const SizedBox(height: 24),

          // --- 2. Card with Bar Charts Placeholder ---
          _buildChartCard(context),

          const SizedBox(height: 32),

          // --- 3. Expense History Header ---
          const Text(
            "Riwayat Pengeluaran Hari Ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // --- 4. Expense History List ---
          ...mockExpenses.map((expense) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildExpenseItem(
                icon: expense['icon'],
                category: expense['category'],
                amount: expense['amount'],
                color: expense['color'],
              ),
            );
          }).toList(),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// Widget utama yang mengelola navigasi
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Indeks 0: Dashboard/Home Content
    const DashboardContent(),
    // Indeks 1: Halaman Create Transaksi
    const CreatePage(),
    // Indeks 2: Halaman User Setting
    const SettingsPage(),
  ];

  final List<String> _titles = const [
    "Dashboard",
    "Buat Transaksi",
    "Pengaturan",
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul AppBar disesuaikan dengan halaman yang aktif
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
      body: _pages[_currentIndex],

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: AppColor.white,
          selectedItemColor: AppColor.primary, // Warna ikon/teks aktif
          unselectedItemColor:
              AppColor.textSecondary, // Warna ikon/teks tidak aktif
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed, // Memastikan semua item terlihat
          elevation: 0, // Dihilangkan karena shadow sudah diatur di Container
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              // Menggunakan Floating Action Button style di tengah
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
