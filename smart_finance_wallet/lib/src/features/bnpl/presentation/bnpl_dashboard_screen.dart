import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_finance_wallet/src/core/presentation/widgets/glass_card.dart';
import '../domain/bnpl_model.dart';
import 'bnpl_providers.dart';
import 'create_bnpl_screen.dart';

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

    // Mock Limit for demo
    const double creditLimit = 5000.0;
    final double utilization = (totalDue / creditLimit).clamp(0.0, 1.0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Credit Line'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Color(0xFF651FFF),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'upcoming'),
              Tab(text: 'settled'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF121212),
                Theme.of(context)
                    .colorScheme
                    .tertiaryContainer
                    .withOpacity(0.1),
                const Color(0xFF1A1A1A),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Credit Utilization Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GlassCard(
                    opacity: 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL DUE',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${totalDue.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ],
                              ),
                              CircularProgressIndicator(
                                value: utilization,
                                backgroundColor: Colors.white10,
                                color: totalDue > creditLimit * 0.8
                                    ? Colors.redAccent
                                    : const Color(0xFF651FFF),
                                strokeWidth: 8,
                                strokeCap: StrokeCap.round,
                              ).animate().fadeIn(delay: 200.ms),
                            ],
                          ),
                          const SizedBox(height: 24),
                          LinearProgressIndicator(
                            value: utilization,
                            backgroundColor: Colors.white10,
                            color: const Color(0xFF651FFF),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ).animate().slideX(
                              duration: 600.ms, curve: Curves.easeOutCubic),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(utilization * 100).toInt()}% Used',
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                              Text(
                                'Limit: \$${creditLimit.toInt()}',
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2, end: 0),
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
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateBnplTransactionScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFF651FFF),
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text('Add Bill',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined,
                size: 48, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              isHistory ? 'No settled transactions' : 'No upcoming payments',
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
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
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: Colors.red.shade900.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (direction) {
            ref
                .read(bnplTransactionsProvider.notifier)
                .deleteTransaction(transaction.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${transaction.title} deleted')),
            );
          },
          child: GlassCard(
            opacity: 0.05,
            borderRadius: 16,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isHistory
                          ? Colors.white.withOpacity(0.05)
                          : (isOverdue
                              ? Colors.red.withOpacity(0.1)
                              : const Color(0xFF651FFF).withOpacity(0.1)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isHistory
                          ? Icons.check_circle_outline
                          : Icons.receipt_long,
                      color: isHistory
                          ? Colors.white54
                          : (isOverdue
                              ? Colors.redAccent
                              : const Color(0xFF651FFF)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Due: ${DateFormat('MMM dd').format(transaction.dueDate)}',
                          style: TextStyle(
                              color:
                                  isOverdue ? Colors.redAccent : Colors.white54,
                              fontWeight: isOverdue ? FontWeight.bold : null,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${transaction.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Outfit'),
                      ),
                      if (!isHistory) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(bnplTransactionsProvider.notifier)
                                .markAsPaid(transaction.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFF00E676)
                                        .withOpacity(0.5))),
                            child: const Text('PAY NOW',
                                style: TextStyle(
                                    color: Color(0xFF00E676),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, end: 0),
        );
      },
    );
  }
}
