import '../domain/simulation_model.dart';

class SimulationEngine {
  static SimulationResult runSimulation({
    required double currentBalance,
    required SimulationScenario scenario,
  }) {
    // 1. Calculate Daily Net Flow
    // Simple linear projection: (Income - Expenses) / 30
    final dailyNetFlow =
        (scenario.monthlyIncome - scenario.monthlyExpenses) / 30;

    // 2. Project Future Balances
    double balance7 = currentBalance + (dailyNetFlow * 7);
    double balance30 = currentBalance + (dailyNetFlow * 30);
    double balance90 = currentBalance + (dailyNetFlow * 90);

    // 3. Apply Scenario Adjustments
    if (scenario.oneTimePurchaseAmount > 0) {
      balance7 -= scenario.oneTimePurchaseAmount;
      balance30 -= scenario.oneTimePurchaseAmount;
      balance90 -= scenario.oneTimePurchaseAmount;
    }

    if (scenario.delayPayment) {
      // If payment delayed, we 'keep' the money temporarily but incur simulated penalty later?
      // Or we simulate the impact of late fees.
      // Let's simulate a late fee impact after 30 days
      balance30 -= 50; // Mock late fee
      balance90 -= 100; // Accumulated interest
    } else {
      // Assume pending BNPL is paid within 30 days evenly
      balance30 -= scenario.pendingBnplAmount;
      balance90 -= scenario.pendingBnplAmount;
      // Pro-rate for 7 days
      balance7 -= (scenario.pendingBnplAmount / 4);
    }

    // 4. Calculate Credit Score Impact
    double impact = 0;
    String outcome = "Stable outlook.";

    if (balance30 < 0) {
      impact -= 15;
      outcome = "Critical: Projection shows negative balance in 30 days.";
    } else if (scenario.delayPayment) {
      impact -= 25;
      outcome = "Warning: Delayed payments will severely impact credit score.";
    } else if (scenario.oneTimePurchaseAmount > currentBalance * 0.5) {
      impact -= 5;
      outcome = "Caution: High expenditure may strain liquidity.";
    } else {
      impact += 5;
      outcome = "On track. Positive savings rate projected.";
    }

    return SimulationResult(
      predictedBalance7Days: balance7,
      predictedBalance30Days: balance30,
      predictedBalance90Days: balance90,
      predictedCreditScoreImpact: impact,
      outcomeDescription: outcome,
    );
  }
}
