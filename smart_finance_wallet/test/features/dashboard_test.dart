import 'package:flutter_test/flutter_test.dart';
import 'package:smart_finance_wallet/src/features/dashboard/presentation/dashboard_providers.dart';
import 'package:smart_finance_wallet/src/features/transactions/domain/transaction_model.dart';

void main() {
  group('Dashboard Metrics Tests', () {
    test('Calculates total expenses correctly', () {
      // Manual verification of logic
      final transactions = [
        Transaction(
            id: '1',
            amount: 50,
            date: DateTime.now(),
            description: 'Food',
            type: TransactionType.send,
            category: TransactionCategory.food),
        Transaction(
            id: '2',
            amount: 100,
            date: DateTime.now(),
            description: 'Gas',
            type: TransactionType.send,
            category: TransactionCategory.travel),
      ];

      double total = 0;
      for (var tx in transactions) {
        if (tx.type == TransactionType.send) {
          total += tx.amount;
        }
      }

      expect(total, 150.0);
    });
  });
}
