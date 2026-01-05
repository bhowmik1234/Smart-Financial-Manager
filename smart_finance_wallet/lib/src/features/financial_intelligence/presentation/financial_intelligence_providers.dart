import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/financial_health_model.dart';
import '../domain/simulation_model.dart';
import '../domain/recommendation_model.dart';
import '../logic/credit_scoring_engine.dart';
import '../logic/spending_dna_engine.dart';
import '../logic/simulation_engine.dart';
import '../logic/recommendation_engine.dart';
import '../../transactions/presentation/wallet_providers.dart';
import '../../bnpl/presentation/bnpl_providers.dart';
import '../../transactions/domain/transaction_model.dart';

// 1. Credit Health Provider
final creditHealthProvider = Provider<CreditHealthScore>((ref) {
  final balance = ref.watch(balanceProvider);
  final bnplTransactions = ref.watch(bnplTransactionsProvider);

  // Mock missed payments for now (can be real if we track history)
  // Logic: if any settled transaction was paid AFTER due date
  final missedPayments = bnplTransactions
      .where((t) =>
          t.isPaid && t.paidDate != null && t.paidDate!.isAfter(t.dueDate))
      .length;

  return CreditScoringEngine.calculateScore(
    walletBalance: balance,
    bnplTransactions: bnplTransactions,
    missedPaymentsCount: missedPayments,
  );
});

// 2. Spending DNA Provider
final spendingDnaProvider = Provider<SpendingDna>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final balance = ref.watch(balanceProvider);
  final bnplTransactions = ref.watch(bnplTransactionsProvider);

  // Calculate Monthly Inflow/Outflow based on last 30 days
  final now = DateTime.now();
  final last30Days = now.subtract(const Duration(days: 30));

  double inflow = 0;
  double outflow = 0;

  for (var t in transactions) {
    if (t.date.isAfter(last30Days)) {
      if (t.type == TransactionType.receive || t.type == TransactionType.add) {
        inflow += t.amount;
      } else {
        outflow += t.amount;
      }
    }
  }

  // Fallback for demo if no transactions
  if (inflow == 0 && outflow == 0) {
    inflow = 5000;
    outflow = 3000;
  }

  return SpendingDnaEngine.analyze(
    walletBalance: balance,
    monthlyInflow: inflow,
    monthlyOutflow: outflow,
    bnplCount: bnplTransactions.length,
  );
});

// 3. Simulation State Provider
class SimulationStateNotifier extends StateNotifier<SimulationScenario> {
  SimulationStateNotifier()
      : super(const SimulationScenario(
          monthlyIncome: 5000,
          monthlyExpenses: 3000,
          pendingBnplAmount: 0,
        ));

  void updateScenario({
    double? monthlyIncome,
    double? monthlyExpenses,
    double? pendingBnplAmount,
    double? oneTimePurchaseAmount,
    bool? delayPayment,
  }) {
    state = state.copyWith(
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      pendingBnplAmount: pendingBnplAmount,
      oneTimePurchaseAmount: oneTimePurchaseAmount,
      delayPayment: delayPayment,
    );
  }
}

final simulationScenarioProvider =
    StateNotifierProvider<SimulationStateNotifier, SimulationScenario>((ref) {
  return SimulationStateNotifier();
});

final simulationResultProvider = Provider<SimulationResult>((ref) {
  final scenario = ref.watch(simulationScenarioProvider);
  final balance = ref.watch(balanceProvider);
  final bnplTransactions = ref.watch(bnplTransactionsProvider);

  // Auto-update pending BNPL in scenario based on real data
  final realPendingBnpl = bnplTransactions
      .where((t) => !t.isPaid)
      .fold(0.0, (sum, t) => sum + t.amount);

  // Combine real pending with user scenario override if any
  // For simplicity, let's assume the user wants to simulate based on real + manual adjustments
  // But strictly, we should use the scenario's pending amount if set, or default to real.
  // Here we'll default the scenario's pending amount to real data if it wasn't manually set?
  // Actually, simpler to just pass the real pending amount if the scenario one is 0 (default)

  final effectiveScenario = scenario.pendingBnplAmount == 0
      ? scenario.copyWith(pendingBnplAmount: realPendingBnpl)
      : scenario;

  return SimulationEngine.runSimulation(
      currentBalance: balance, scenario: effectiveScenario);
});

// 4. Recommendations Provider
final recommendationsProvider = Provider<List<FinancialRecommendation>>((ref) {
  final creditScore = ref.watch(creditHealthProvider);
  final balance = ref.watch(balanceProvider);
  final bnplTransactions = ref.watch(bnplTransactionsProvider);

  final totalBnplDue = bnplTransactions
      .where((t) => !t.isPaid)
      .fold(0.0, (sum, t) => sum + t.amount);

  return RecommendationEngine.generateRecommendations(
    creditScore: creditScore,
    walletBalance: balance,
    totalBnplDue: totalBnplDue,
  );
});
