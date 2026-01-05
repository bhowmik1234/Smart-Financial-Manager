import 'package:flutter/foundation.dart';

@immutable
class SimulationScenario {
  final double monthlyIncome;
  final double monthlyExpenses;
  final double pendingBnplAmount;
  final double oneTimePurchaseAmount; // For "What-if"
  final bool delayPayment; // Simulate delayed BNPL payment

  const SimulationScenario({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.pendingBnplAmount,
    this.oneTimePurchaseAmount = 0.0,
    this.delayPayment = false,
  });

  SimulationScenario copyWith({
    double? monthlyIncome,
    double? monthlyExpenses,
    double? pendingBnplAmount,
    double? oneTimePurchaseAmount,
    bool? delayPayment,
  }) {
    return SimulationScenario(
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      pendingBnplAmount: pendingBnplAmount ?? this.pendingBnplAmount,
      oneTimePurchaseAmount:
          oneTimePurchaseAmount ?? this.oneTimePurchaseAmount,
      delayPayment: delayPayment ?? this.delayPayment,
    );
  }
}

@immutable
class SimulationResult {
  final double predictedBalance7Days;
  final double predictedBalance30Days;
  final double predictedBalance90Days;
  final double predictedCreditScoreImpact; // E.g., -5, +2
  final String outcomeDescription;

  const SimulationResult({
    required this.predictedBalance7Days,
    required this.predictedBalance30Days,
    required this.predictedBalance90Days,
    required this.predictedCreditScoreImpact,
    required this.outcomeDescription,
  });
}
