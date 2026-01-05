import '../domain/financial_health_model.dart';

class SpendingDnaEngine {
  static SpendingDna analyze({
    required double walletBalance,
    required double monthlyInflow,
    required double monthlyOutflow,
    required int bnplCount,
  }) {
    // 0. Calculate Savings Rate
    double savingsRate = 0;
    if (monthlyInflow > 0) {
      savingsRate = (monthlyInflow - monthlyOutflow) / monthlyInflow;
    }

    // 1. Determine Persona
    SpendingPersona persona;
    List<String> traits = [];

    if (savingsRate > 0.4 && bnplCount < 2) {
      persona = SpendingPersona.planner;
      traits.add("High Saver");
      traits.add("Strategic Spender");
    } else if (savingsRate > 0.1 && walletBalance > 5000) {
      persona = SpendingPersona.stabilitySeeker;
      traits.add("Cash Reserve Builder");
    } else if (bnplCount > 4) {
      persona = SpendingPersona.impulseOptimizer;
      traits.add("Credit Maximizer");
      traits.add("Reward Hunter");
    } else if (savingsRate < 0 && walletBalance < 1000) {
      persona = SpendingPersona.riskTaker;
      traits.add("Living on Edge");
      traits.add("High Liquidity Risk");
    } else {
      persona = SpendingPersona.stabilitySeeker; // Default
      traits.add("Balanced Walker");
    }

    return SpendingDna(
      persona: persona,
      traits: traits,
      savingsRate: savingsRate,
    );
  }
}
