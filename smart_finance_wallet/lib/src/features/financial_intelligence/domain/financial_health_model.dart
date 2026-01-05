import 'package:flutter/foundation.dart';

enum RiskTier { low, medium, high, critical }

enum SpendingPersona {
  planner, // Consistent savings, few BNPLs
  impulseOptimizer, // High rewards, high BNPL but paid on time
  stabilitySeeker, // Low activity, high balance maintenance
  riskTaker, // High BNPL, frequent low balance
  unknown,
}

@immutable
class CreditHealthScore {
  final int score; // 0-100
  final RiskTier riskTier;
  final List<String> reasons;
  final double recommendedBnplLimit;

  const CreditHealthScore({
    required this.score,
    required this.riskTier,
    required this.reasons,
    required this.recommendedBnplLimit,
  });

  bool get isHealthy => score >= 70;
}

@immutable
class SpendingDna {
  final SpendingPersona persona;
  final List<String> traits; // "High Impulse", "Reward Hunter"
  final double savingsRate; // 0.0 - 1.0

  const SpendingDna({
    required this.persona,
    required this.traits,
    required this.savingsRate,
  });
}
