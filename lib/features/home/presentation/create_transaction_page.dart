import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_color.dart';
import 'package:uuid/uuid.dart';
import '../../../../models/transaction.dart';
import '../../../../models/transaction_category.dart';

// Definisi callback untuk mengirim transaksi baru
typedef AddTransactionCallback = void Function(Transaction newTransaction);

// State Management untuk form
class CreatePage extends StatefulWidget {
  // Callback untuk mengirim data transaksi baru ke Home/Stateful Widget parent
  final AddTransactionCallback onAddTransaction;

  const CreatePage({super.key, required this.onAddTransaction});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // State Form
  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory _selectedCategory = expenseCategories.first;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Daftar kategori yang tersedia berdasarkan tipe
  List<TransactionCategory> get _availableCategories =>
      _selectedType == TransactionType.income
          ? incomeCategories
          : expenseCategories;

  @override
  void initState() {
    super.initState();
    // Inisialisasi kategori saat awal berdasarkan tipe default
    _selectedCategory = _availableCategories.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // --- Fungsi Picker Tanggal ---
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- Fungsi Simpan Transaksi ---
  void _submitTransaction() {
    final double? amount = double.tryParse(
      _amountController.text.replaceAll('.', '').replaceAll(',', ''),
    );

    if (amount == null || amount <= 0) {
      // Tampilkan error jika jumlah tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah transaksi tidak valid.')),
      );
      return;
    }

    final newTransaction = Transaction(
      id: const Uuid().v4(), // Generate ID unik
      type: _selectedType,
      category: _selectedCategory.name,
      amount: amount,
      note:
          _noteController.text.trim().isEmpty
              ? 'Tanpa Catatan'
              : _noteController.text.trim(),
      date: _selectedDate,
      color: _selectedCategory.color,
    );

    // Kirim data transaksi ke parent widget melalui callback
    widget.onAddTransaction(newTransaction);

    // Tampilkan pesan sukses dan reset form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Transaksi ${_selectedType == TransactionType.income ? "Pemasukan" : "Pengeluaran"} (${_selectedCategory.name}) berhasil ditambahkan.',
        ),
      ),
    );

    _resetForm();
  }

  // --- Fungsi Reset Form ---
  void _resetForm() {
    setState(() {
      _selectedType = TransactionType.expense;
      _selectedCategory = expenseCategories.first;
      _amountController.clear();
      _noteController.clear();
      _selectedDate = DateTime.now();
    });
  }

  // --- Widget Kategori Dropdown ---
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<TransactionCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items:
          _availableCategories.map((category) {
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
      onChanged: (TransactionCategory? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCategory = newValue;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- 1. Pemilih Tipe Transaksi (Income/Expense) ---
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text(
                    'Pengeluaran 💸',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  selected: _selectedType == TransactionType.expense,
                  selectedColor: AppColor.error.withOpacity(0.1),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = TransactionType.expense;
                        _selectedCategory = expenseCategories.first;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: const Text(
                    'Pemasukan 💰',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  selected: _selectedType == TransactionType.income,
                  selectedColor: AppColor.secondary,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = TransactionType.income;
                        _selectedCategory = incomeCategories.first;
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- 2. Kategori Dropdown ---
          _buildCategoryDropdown(),

          const SizedBox(height: 20),

          // --- 3. Jumlah (Amount) Input ---
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah Transaksi (misal: 50000)',
              prefixText: 'Rp ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- 4. Catatan (Note) Input ---
          TextFormField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Catatan (Opsional)',
              hintText: 'Misal: Beli makan siang di Warkop',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- 5. Pemilih Tanggal ---
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tanggal: ${DateFormat('dd MMMM yyyy').format(_selectedDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_rounded),
                label: const Text('Pilih Tanggal'),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // --- 6. Tombol Simpan ---
          ElevatedButton(
            onPressed: _submitTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Simpan Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
