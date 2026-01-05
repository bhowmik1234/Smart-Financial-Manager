import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_wallet/src/features/bnpl/presentation/bnpl_dashboard_screen.dart';
import 'package:smart_finance_wallet/src/features/bnpl/presentation/bnpl_providers.dart';
import 'package:smart_finance_wallet/src/features/bnpl/domain/bnpl_model.dart';

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
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bnplTransactionsProvider.overrideWith((ref) => [transaction]),
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
      expect(find.text('\$1500.00'), findsOneWidget);
    });

    testWidgets('BnplDashboardScreen shows no items message when empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bnplTransactionsProvider.overrideWith((ref) => []),
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
