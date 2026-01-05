import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../domain/bnpl_model.dart';
import 'bnpl_providers.dart';
import 'create_bnpl_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BnplDashboardScreen extends ConsumerWidget {
  const BnplDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(bnplTransactionsProvider);

    final activeTransactions = transactions.where((t) => !t.isPaid).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final settledTransactions = transactions.where((t) => t.isPaid).toList()
      ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

    final totalDue = activeTransactions.fold(
        0.0, (previousValue, element) => previousValue + element.amount);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BNPL Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Settled'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Due:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalDue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _TransactionList(
                      transactions: activeTransactions, isHistory: false),
                  _TransactionList(
                      transactions: settledTransactions, isHistory: true),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateBnplTransactionScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  final List<BnplTransaction> transactions;
  final bool isHistory;

  const _TransactionList({
    required this.transactions,
    required this.isHistory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          isHistory ? 'No settled transactions' : 'No upcoming payments',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isOverdue = !isHistory &&
            transaction.dueDate
                .isBefore(DateTime.now().subtract(const Duration(days: 1)));

        return Dismissible(
          key: Key(transaction.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            ref
                .read(bnplTransactionsProvider.notifier)
                .deleteTransaction(transaction.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${transaction.title} deleted')),
            );
          },
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isOverdue
                  ? const BorderSide(color: Colors.red)
                  : BorderSide.none,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    isHistory ? Colors.grey[200] : Colors.blue[100],
                child: Icon(
                  isHistory ? Icons.check : Icons.calendar_today,
                  color: isHistory ? Colors.grey : Colors.blue,
                ),
              ),
              title: Text(
                transaction.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Due: ${DateFormat('MMM dd, yyyy').format(transaction.dueDate)}',
                style: TextStyle(
                  color: isOverdue ? Colors.red : null,
                  fontWeight: isOverdue ? FontWeight.bold : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isHistory)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      color: Colors.green,
                      tooltip: 'Mark as Paid',
                      onPressed: () {
                        ref
                            .read(bnplTransactionsProvider.notifier)
                            .markAsPaid(transaction.id);
                      },
                    ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (50 * index).ms).slideX(),
        );
      },
    );
  }
}
