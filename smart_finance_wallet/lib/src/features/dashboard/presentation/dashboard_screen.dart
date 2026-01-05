import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_finance_wallet/src/core/presentation/widgets/glass_card.dart';
import 'dashboard_providers.dart';
import '../../transactions/domain/transaction_model.dart';
import '../domain/recommendation_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(dashboardMetricsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('CRED Money'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          fontFamily: 'Outfit', // Ensure font is loaded
          letterSpacing: 1.2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => context.push('/notification-settings'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {}, // TODO: Open notifications
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0F0F),
              const Color(0xFF1A1A1A),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Net Worth Card (Premium Credit Card Look)
                _NetWorthCard(metrics: metrics)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
                const SizedBox(height: 32),

                // 2. Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                const _QuickActions()
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideX(begin: 0.1, end: 0),
                const SizedBox(height: 32),

                // 3. Smart Recommendations
                if (metrics.recommendations.isNotEmpty) ...[
                  const Text(
                    'INSIGHTS',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  _RecommendationsList(recommendations: metrics.recommendations)
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .slideX(),
                  const SizedBox(height: 32),
                ],

                // 4. Analysis Grid (Two columns)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('LIMIT USED',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2))
                              .animate()
                              .fadeIn(delay: 600.ms),
                          const SizedBox(height: 12),
                          _CreditUtilizationCard(metrics: metrics)
                              .animate()
                              .fadeIn(delay: 700.ms)
                              .scale(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SPEND SPLIT',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2))
                              .animate()
                              .fadeIn(delay: 800.ms),
                          const SizedBox(height: 12),
                          if (metrics.categoryExpenses.isNotEmpty)
                            AspectRatio(
                              aspectRatio: 1,
                              child: _ExpensePieChart(
                                      categoryExpenses:
                                          metrics.categoryExpenses)
                                  .animate()
                                  .scale(delay: 900.ms),
                            )
                          else
                            const SizedBox(
                                height: 100,
                                child: Center(
                                    child: Text('No Data',
                                        style:
                                            TextStyle(color: Colors.white54)))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
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
    return GlassCard(
      opacity: 0.1,
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL BALANCE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${metrics.netWorth.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${metrics.rewardPoints}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'INCOME',
                    value: '+${metrics.totalIncome.toStringAsFixed(0)}',
                    color: const Color(0xFF00E676),
                  ),
                ),
                Container(
                    width: 1, height: 24, color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: _StatItem(
                      label: 'EXPENSE',
                      value: '-${metrics.totalExpense.toStringAsFixed(0)}',
                      color: const Color(0xFFFF5252),
                    ),
                  ),
                ),
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

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Outfit')),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _ActionButton(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Wallet',
            color: const Color(0xFF2979FF),
            onTap: () => context.push('/wallet'),
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: Icons.credit_score_rounded,
            label: 'BNPL',
            color: const Color(0xFF651FFF),
            onTap: () => context.push('/bnpl'),
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: Icons.diamond_rounded,
            label: 'Rewards',
            color: const Color(0xFFFF4081),
            onTap: () => context.push('/rewards'),
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: Icons.pie_chart_rounded,
            label: 'Analysis',
            color: Colors.tealAccent,
            onTap: () {}, // Future feature
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Dark button bg
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 20, // Glow effect
                  spreadRadius: -5,
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsList extends StatelessWidget {
  final List<Recommendation> recommendations;
  const _RecommendationsList({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final rec = recommendations[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GlassCard(
              opacity: 0.1,
              borderRadius: 20,
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: rec.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(rec.icon, color: rec.color, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rec.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      rec.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'TAP TO VIEW ->',
                        style: TextStyle(
                            color: rec.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CreditUtilizationCard extends StatelessWidget {
  final DashboardMetrics metrics;
  const _CreditUtilizationCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final color = metrics.creditUtilization > 0.7
        ? const Color(0xFFFF5252)
        : metrics.creditUtilization > 0.4
            ? Colors.orangeAccent
            : const Color(0xFF00E676);

    return GlassCard(
      opacity: 0.05,
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: metrics.creditUtilization,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    color: color,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(metrics.creditUtilization * 100).toInt()}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$${metrics.bnplTotalDue.toInt()} / \$10k',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
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
        sectionsSpace: 4, // Spacing between sections
        centerSpaceRadius: 0,
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
      final category = categories[i];
      final value = widget.categoryExpenses[category]!;
      // final percentage = (value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: _getColorForCategory(category),
        value: value,
        title: '', // Minimalist
        radius: isTouched ? 110 : 100, // Visual pop
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                    '${category.name.toUpperCase()}\n\$${value.toInt()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10)),
              )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    });
  }

  Color _getColorForCategory(TransactionCategory category) {
    // Generate distinct neon colors
    final colors = [
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.yellowAccent,
      Colors.blueAccent,
      Colors.indigoAccent,
      Colors.tealAccent,
      Colors.redAccent,
    ];
    return colors[category.index % colors.length];
  }
}
