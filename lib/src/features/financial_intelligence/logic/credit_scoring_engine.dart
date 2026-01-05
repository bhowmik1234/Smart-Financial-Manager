import '../domain/financial_health_model.dart';
import '../../bnpl/domain/bnpl_model.dart';

class CreditScoringEngine {
  /// Deterministic rule-based scoring
  static CreditHealthScore calculateScore({
    required double walletBalance,
    required List<BnplTransaction> bnplTransactions,
    required int missedPaymentsCount,
  }) {
    int score = 750; // Base score (Standard starting point)
    List<String> reasons = [];
    double recommendedLimit = 5000.0;

    // 1. Punctuality Impact
    if (missedPaymentsCount > 0) {
      int penalty = missedPaymentsCount * 50;
      score -= penalty;
      reasons.add('Missed $missedPaymentsCount payments (-$penalty pts)');
    } else {
      score += 20;
      reasons.add('Perfect payment history (+20 pts)');
    }

    // 2. BNPL Utilization Impact
    final totalBnplDue = bnplTransactions
        .where((t) => !t.isPaid)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Assume a simulated 'max standard limit' based on balance
    final safeLimit = (walletBalance * 0.5).clamp(1000.0, 10000.0);

    if (totalBnplDue > safeLimit) {
      score -= 30;
      reasons.add('High BNPL utilization relative to balance (-30 pts)');
    } else if (totalBnplDue > 0) {
      score += 10;
      reasons.add('Responsible BNPL usage (+10 pts)');
    }

    // 3. Wallet Stability Impact
    if (walletBalance < 1000) {
      score -= 20;
      reasons.add('Low wallet liquidity (-20 pts)');
    } else if (walletBalance > 10000) {
      score += 30;
      reasons.add('Strong cash reserve (+30 pts)');
    }

    // Determine Risk Tier
    // Map internal 0-1000+ score to 0-100 presentation score
    final normalizedScore = (score / 10).clamp(0, 100).toInt();

    RiskTier tier;
    if (normalizedScore >= 80) {
      tier = RiskTier.low;
      recommendedLimit = 10000.0;
    } else if (normalizedScore >= 60) {
      tier = RiskTier.medium;
      recommendedLimit = 5000.0;
    } else if (normalizedScore >= 40) {
      tier = RiskTier.high;
      recommendedLimit = 2000.0;
    } else {
      tier = RiskTier.critical;
      recommendedLimit = 500.0;
    }

    // Cap limit by balance reality
    if (walletBalance < recommendedLimit * 0.2) {
      recommendedLimit = walletBalance * 2;
    }

    return CreditHealthScore(
      score: normalizedScore,
      riskTier: tier,
      reasons: reasons,
      recommendedBnplLimit: recommendedLimit,
    );
  }
}
