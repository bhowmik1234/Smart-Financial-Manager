import 'package:hive_flutter/hive_flutter.dart';
import '../domain/bnpl_model.dart';

class BnplRepository {
  static const String boxName = 'bnpl_transactions';

  Future<void> init() async {
    await Hive.openBox<BnplTransaction>(boxName);
  }

  Box<BnplTransaction> get _box => Hive.box<BnplTransaction>(boxName);

  List<BnplTransaction> getTransactions() {
    return _box.values.toList()..sort((a, b) => b.dueDate.compareTo(a.dueDate));
  }

  List<BnplTransaction> getActiveTransactions() {
    return _box.values.where((t) => !t.isPaid).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate)); // Earliest due first
  }

  List<BnplTransaction> getSettledTransactions() {
    return _box.values.where((t) => t.isPaid).toList()
      ..sort((a, b) => b.dueDate.compareTo(a.dueDate)); // Latest paid first
  }

  Future<void> addTransaction(BnplTransaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> markAsPaid(String id) async {
    final transaction = _box.get(id);
    if (transaction != null) {
      transaction.isPaid = true;
      await transaction.save();
    }
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }
}
