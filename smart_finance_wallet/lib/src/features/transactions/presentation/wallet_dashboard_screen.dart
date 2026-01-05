import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/transaction_card.dart';
import 'wallet_providers.dart';
import '../domain/transaction_model.dart';
import '../../authentication/presentation/auth_providers.dart';

class WalletDashboardScreen extends ConsumerStatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  ConsumerState<WalletDashboardScreen> createState() =>
      _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends ConsumerState<WalletDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh data on init (in case coming back from other screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(balanceProvider.notifier).refresh();
      ref.read(transactionListProvider.notifier); // Trigger build
    });
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(balanceProvider);
    final transactions = ref.watch(transactionListProvider);
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(balance),
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.push('/wallet/add-money'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Money'),
                        ),
                        FilledButton.icon(
                          onPressed: () => context.push('/wallet/send-money'),
                          icon: const Icon(Icons.send),
                          label: const Text('Send'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/bnpl'),
                          icon: const Icon(Icons.history_edu),
                          label: const Text('BNPL'),
                        ),
                        TextButton.icon(
                          onPressed: () => context.push('/rewards'),
                          icon: const Icon(Icons.stars, color: Colors.amber),
                          label: const Text('Rewards'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text('No transactions yet'))
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/transaction_card.dart';

// ... (existing imports)

                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return TransactionCard(transaction: tx)
                              .animate()
                              .fadeIn(delay: (50 * index).ms)
                              .slideX(begin: 0.1, end: 0);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
