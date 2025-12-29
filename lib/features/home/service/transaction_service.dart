import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/transaction.dart';

class TransactionService {
  final _supabase = Supabase.instance.client;

  // Mendapatkan stream transaksi (Real-time)
  Stream<List<Transaction>> getTransactionsStream() {
    final userId = _supabase.auth.currentUser!.id;

    return _supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('date', ascending: false)
        .map((data) => data.map((map) => Transaction.fromMap(map)).toList());
  }

  // Menyimpan transaksi baru
  Future<void> saveTransaction(Transaction transaction) async {
    await _supabase.from('transactions').insert(transaction.toMap());
  }
}
