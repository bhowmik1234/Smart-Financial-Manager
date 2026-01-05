import 'package:hive_flutter/hive_flutter.dart';
import '../domain/transaction_model.dart';

class WalletRepository {
  static const String walletBoxName = 'walletbox';
  static const String transactionsBoxName = 'transactionsbox';

  Future<void> init() async {
    await Hive.openBox(walletBoxName);
    await Hive.openBox<Transaction>(transactionsBoxName);
  }

  Box get _walletBox => Hive.box(walletBoxName);
  Box<Transaction> get _transactionsBox => Hive.box<Transaction>(transactionsBoxName);

  // Balance Management
  double getBalance() {
    return _walletBox.get('balance', defaultValue: 0.0) as double;
  }

  Future<void> updateBalance(double newBalance) async {
    await _walletBox.put('balance', newBalance);
  }

  // Transaction Management
  List<Transaction> getTransactions() {
    final transactions = _transactionsBox.values.toList();
    transactions.sort((a, b) => b.date.compareTo(a.date)); // Sort by date desc
    return transactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsBox.add(transaction);
  }

  Future<void> clearAll() async {
    await _walletBox.clear();
    await _transactionsBox.clear();
  }
}
