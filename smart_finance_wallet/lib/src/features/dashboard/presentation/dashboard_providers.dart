import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/domain/transaction_model.dart';
import '../../transactions/presentation/wallet_providers.dart';
import '../../bnpl/presentation/bnpl_providers.dart';
import '../../rewards/presentation/rewards_providers.dart';
import '../domain/recommendation_model.dart';

part 'dashboard_providers.g.dart';

class DashboardMetrics {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double netWorth;
  final Map<TransactionCategory, double> categoryExpenses;
  final double bnplTotalDue;
  final double creditUtilization; // 0.0 to 1.0
  final int rewardPoints;
  final List<Recommendation> recommendations;

  DashboardMetrics({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.netWorth,
    required this.categoryExpenses,
    required this.bnplTotalDue,
    required this.creditUtilization,
    required this.rewardPoints,
    required this.recommendations,
  });
}

@riverpod
DashboardMetrics dashboardMetrics(DashboardMetricsRef ref) {
  final walletBalance = ref.watch(balanceProvider);
  final transactions = ref.watch(transactionListProvider);
  final bnplTransactions = ref.watch(bnplTransactionsProvider);
  final rewardPoints = ref.watch(coinBalanceProvider);

  // 1. Calculations: Income & Expense
  double totalIncome = 0;
  double totalExpense = 0;
  final Map<TransactionCategory, double> categoryExpenses = {};

  for (final tx in transactions) {
    if (tx.type == TransactionType.add || tx.type == TransactionType.receive) {
      totalIncome += tx.amount;
    } else if (tx.type == TransactionType.send) {
      totalExpense += tx.amount;
      categoryExpenses[tx.category] =
          (categoryExpenses[tx.category] ?? 0) + tx.amount;
    }
  }

  // 2. Calculations: BNPL & Credit Utilization
  double bnplTotalDue = 0;
  for (final tx in bnplTransactions) {
    if (!tx.isPaid) {
      bnplTotalDue += tx.amount;
    }
  }

  // Assuming a static credit limit for now, e.g., $10,000
  const double creditLimit = 10000;
  final double creditUtilization = (bnplTotalDue / creditLimit).clamp(0.0, 1.0);

  // 3. Net Worth (Wallet Balance - Debt)
  final double netWorth = walletBalance - bnplTotalDue;

  // 4. Recommendations Generation
  final List<Recommendation> recommendations = [];

  // Suggest Paying BNPL for Rewards
  final unpaidBnpl = bnplTransactions.where((t) => !t.isPaid).toList();
  if (unpaidBnpl.isNotEmpty) {
    recommendations.add(Recommendation(
      id: 'bnpl-pay-early',
      title: 'Earn Extra Rewards',
      description:
          'Pay your ${unpaidBnpl.length} active BNPL items early to earn 5 bonus coins per item!',
      type: RecommendationType.reward,
      severity: RecommendationSeverity.info,
      actionType: ActionType.payBnpl,
    ));
  }

  // Credit Utilization Warning
  if (creditUtilization > 0.5) {
    recommendations.add(Recommendation(
      id: 'high-credit-util',
      title: 'Reduce Credit Usage',
      description:
          'Your credit utilization is ${(creditUtilization * 100).toStringAsFixed(0)}%. Pay off debts to improve your score.',
      type: RecommendationType.credit,
      severity: creditUtilization > 0.8
          ? RecommendationSeverity.critical
          : RecommendationSeverity.warning,
      actionType: ActionType.payBnpl,
    ));
  }

  // Spending Spike Detection (Simplified)
  if (categoryExpenses.isNotEmpty) {
    final topCategory =
        categoryExpenses.entries.reduce((a, b) => a.value > b.value ? a : b);
    // Arbitrary threshold for demo: if top category is > 40% of total expense
    if (totalExpense > 0 && (topCategory.value / totalExpense) > 0.4) {
      recommendations.add(Recommendation(
        id: 'spending-spike',
        title: 'High Spending in ${topCategory.key.name.toUpperCase()}',
        description:
            'You spent \$${topCategory.value.toStringAsFixed(0)} on ${topCategory.key.name}. Try to reduce this by 10% next week.',
        type: RecommendationType.spending,
        severity: RecommendationSeverity.warning,
        actionType: ActionType.viewSpending,
      ));
    }
  }

  // Savings Projection
  if (totalIncome > 0) {
    final savingsRate = ((totalIncome - totalExpense) / totalIncome * 100);
    if (savingsRate < 10) {
      recommendations.add(Recommendation(
        id: 'low-savings',
        title: 'Boost Your Savings',
        description:
            'You are saving only ${savingsRate.toStringAsFixed(1)}%. Aim for 20% by cutting non-essential expenses.',
        type: RecommendationType.savings,
        severity: RecommendationSeverity.info,
        actionType: ActionType.none,
      ));
    }
  }

  return DashboardMetrics(
    totalBalance: walletBalance,
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    netWorth: netWorth,
    categoryExpenses: categoryExpenses,
    bnplTotalDue: bnplTotalDue,
    creditUtilization: creditUtilization,
    rewardPoints: rewardPoints,
    recommendations: recommendations,
  );
}
