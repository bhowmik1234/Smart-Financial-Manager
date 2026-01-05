import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_wallet/src/features/bnpl/presentation/bnpl_dashboard_screen.dart';
import 'package:smart_finance_wallet/src/features/bnpl/presentation/bnpl_providers.dart';
import 'package:smart_finance_wallet/src/features/bnpl/domain/bnpl_model.dart';
import 'package:smart_finance_wallet/src/features/bnpl/data/bnpl_repository.dart';

void main() {
  group('BNPL Tests', () {
    testWidgets('BnplDashboardScreen displays upcoming and settled tabs',
        (tester) async {
      final transaction = BnplTransaction(
        id: '1',
        title: 'New Laptop',
        amount: 1500.0,
        dueDate: DateTime.now().add(const Duration(days: 10)),
        isPaid: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bnplRepositoryProvider.overrideWith((ref) => FakeBnplRepository(
                  transactions: [transaction],
                )),
          ],
          child: const MaterialApp(
            home: BnplDashboardScreen(),
          ),
        ),
      );

      // Verify Tabs
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Settled'), findsOneWidget);

      // Verify Transaction in Upcoming
      expect(find.text('New Laptop'), findsOneWidget);
      expect(find.text('\$1,500.00'), findsOneWidget);
    });

    testWidgets('BnplDashboardScreen shows no items message when empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bnplRepositoryProvider.overrideWith((ref) => FakeBnplRepository()),
          ],
          child: const MaterialApp(
            home: BnplDashboardScreen(),
          ),
        ),
      );

      expect(find.text('No upcoming payments'), findsOneWidget);
    });
  });
}

class FakeBnplRepository implements BnplRepository {
  final List<BnplTransaction> transactions;

  FakeBnplRepository({this.transactions = const []});

  @override
  List<BnplTransaction> getTransactions() => transactions;

  @override
  List<BnplTransaction> getActiveTransactions() {
    return transactions.where((t) => !t.isPaid).toList();
  }

  @override
  List<BnplTransaction> getSettledTransactions() {
    return transactions.where((t) => t.isPaid).toList();
  }

  @override
  Future<void> addTransaction(BnplTransaction transaction) async {}

  @override
  Future<void> markAsPaid(String id) async {}

  @override
  Future<void> deleteTransaction(String id) async {}

  @override
  Future<void> init() async {}
}
