import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dashboard_providers.dart';
import '../../transactions/domain/transaction_model.dart';
import '../domain/recommendation_model.dart';
// import 'package:smart_finance_wallet/src/features/transactions/presentation/wallet_dashboard_screen.dart'; // Implicitly available via routing

import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(dashboardMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Finance Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/notification-settings'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Worth Card
            _NetWorthCard(metrics: metrics)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),

            // Quick Actions
            const _QuickActions()
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideX(begin: 0.2, end: 0),
            const SizedBox(height: 24),

            // Recommendations
            if (metrics.recommendations.isNotEmpty) ...[
              Text('Smart Recommendations',
                      style: Theme.of(context).textTheme.titleLarge)
                  .animate()
                  .fadeIn(delay: 400.ms),
              const SizedBox(height: 8),
              _RecommendationsSection(recommendations: metrics.recommendations)
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .slideX(begin: -0.1, end: 0),
              const SizedBox(height: 24),
            ],

            // Credit Utilization
            Text('Credit Utilization',
                    style: Theme.of(context).textTheme.titleLarge)
                .animate()
                .fadeIn(delay: 600.ms),
            const SizedBox(height: 8),
            _CreditUtilizationCard(metrics: metrics)
                .animate()
                .fadeIn(delay: 700.ms)
                .scale(),
            const SizedBox(height: 24),

            // Spending Analysis
            if (metrics.categoryExpenses.isNotEmpty) ...[
              Text('Spending Analysis',
                      style: Theme.of(context).textTheme.titleLarge)
                  .animate()
                  .fadeIn(delay: 800.ms),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.3,
                child: _ExpensePieChart(
                    categoryExpenses: metrics.categoryExpenses),
              ).animate().fadeIn(delay: 900.ms).scale(),
            ],
          ].animate(interval: 50.ms).fadeIn(), // Cascade effect
        ),
      ),
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  final DashboardMetrics metrics;

  const _NetWorthCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Net Worth',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${metrics.netWorth.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  label: 'Income',
                  value: '+ \$${metrics.totalIncome.toStringAsFixed(0)}',
                  color: Colors.greenAccent,
                ),
                _StatItem(
                  label: 'Expense',
                  value: '- \$${metrics.totalExpense.toStringAsFixed(0)}',
                  color: Colors.redAccent,
                ),
                _StatItem(
                    label: 'Rewards',
                    value: '${metrics.rewardPoints} pts',
                    color: Colors.amberAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: Icons.account_balance_wallet,
          label: 'Wallet',
          onTap: () => context.push('/wallet'),
        ),
        _ActionButton(
          icon: Icons.history_edu,
          label: 'BNPL',
          onTap: () => context.push('/bnpl'),
        ),
        _ActionButton(
          icon: Icons.stars,
          label: 'Rewards',
          onTap: () => context.push('/rewards'),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  final List<Recommendation> recommendations;

  const _RecommendationsSection({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recommendations.map((rec) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(rec.icon, color: rec.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (rec.severity == RecommendationSeverity.critical)
                      const Icon(Icons.warning_amber, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  rec.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (rec.actionType != ActionType.none) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        switch (rec.actionType) {
                          case ActionType.payBnpl:
                            context.push('/bnpl');
                            break;
                          case ActionType.viewRewards:
                            context.push('/rewards');
                            break;
                          case ActionType.viewSpending:
                            // context.push('/spending'); // Future
                            break;
                          case ActionType.none:
                            break;
                        }
                      },
                      child: Text(
                        _getActionLabel(rec.actionType),
                        style: TextStyle(color: rec.color),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getActionLabel(ActionType type) {
    switch (type) {
      case ActionType.payBnpl:
        return 'Pay Now';
      case ActionType.viewRewards:
        return 'Redeem';
      case ActionType.viewSpending:
        return 'View Details';
      default:
        return '';
    }
  }
}

class _CreditUtilizationCard extends StatelessWidget {
  final DashboardMetrics metrics;

  const _CreditUtilizationCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final color = metrics.creditUtilization > 0.7
        ? Colors.red
        : metrics.creditUtilization > 0.4
            ? Colors.orange
            : Colors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('BNPL Debt'),
                Text(
                    '\$${metrics.bnplTotalDue.toStringAsFixed(0)} / \$10,000', // Mock limit
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: metrics.creditUtilization,
              color: color,
              backgroundColor: Colors.grey[200],
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensePieChart extends StatefulWidget {
  final Map<TransactionCategory, double> categoryExpenses;

  const _ExpensePieChart({required this.categoryExpenses});

  @override
  State<_ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<_ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final List<TransactionCategory> categories =
        widget.categoryExpenses.keys.toList();
    final double total = widget.categoryExpenses.values.reduce((a, b) => a + b);

    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final category = categories[i];
      final value = widget.categoryExpenses[category]!;
      final percentage = (value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: _getColorForCategory(category),
        value: value,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        badgeWidget: _Badge(
          category.name.toUpperCase(),
          size: 40,
          borderColor: _getColorForCategory(category),
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  Color _getColorForCategory(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return Colors.orange;
      case TransactionCategory.travel:
        return Colors.blue;
      case TransactionCategory.bills:
        return Colors.red;
      case TransactionCategory.shopping:
        return Colors.purple;
      case TransactionCategory.entertainment:
        return Colors.pink;
      case TransactionCategory.health:
        return Colors.teal;
      case TransactionCategory.education:
        return Colors.indigo;
      case TransactionCategory.salary:
        return Colors.green;
      case TransactionCategory.investment:
        return Colors.cyan;
      case TransactionCategory.general:
        return Colors.grey;
    }
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
  });
  final String text;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size * 2, // wider for text
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: FittedBox(
            child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
