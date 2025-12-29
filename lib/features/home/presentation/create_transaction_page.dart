import 'package:fintrack/features/home/presentation/widgets/dropdown_field.dart';
import 'package:fintrack/features/home/presentation/widgets/transaction_type_selection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_color.dart';
import '../../../../models/transaction.dart';
import 'package:fintrack/models/transaction_category.dart';

typedef AddTransactionCallback = void Function(Transaction newTransaction);

class CreatePage extends StatefulWidget {
  final AddTransactionCallback onAddTransaction;
  const CreatePage({super.key, required this.onAddTransaction});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  late TransactionCategory _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = expenseCategories.first;
  }

  List<TransactionCategory> get _availableCategories =>
      _selectedType == TransactionType.income
          ? incomeCategories
          : expenseCategories;

  void _handleTypeChange(TransactionType type) {
    setState(() {
      _selectedType = type;
      _selectedCategory = _availableCategories.first;
    });
  }

  // Di dalam _CreatePageState
  void _submitData() {
    final amount = double.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (amount == null || amount <= 0) return;

    // Ambil ID user dari Supabase Auth
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: userId, // Kirim ID user
      type: _selectedType,
      category: _selectedCategory.name,
      amount: amount,
      note:
          _noteController.text.isEmpty ? 'Tanpa Catatan' : _noteController.text,
      date: _selectedDate,
      color: _selectedCategory.color,
    );

    widget.onAddTransaction(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TransactionTypeSelector(
              selectedType: _selectedType,
              onSelected: _handleTypeChange,
            ),
            const SizedBox(height: 20),
            CategoryDropdownField(
              value: _selectedCategory,
              items: _availableCategories,
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _amountController,
              'Jumlah',
              prefix: 'Rp ',
              isNumber: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _noteController,
              'Catatan (Opsional)',
              hint: 'Makan siang',
            ),
            const SizedBox(height: 20),
            _buildDatePicker(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Helper widget kecil yang masih bisa tetap di sini atau dipisah lagi jika sering dipakai
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? prefix,
    String? hint,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate)}'),
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: const Text('Pilih Tanggal'),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
