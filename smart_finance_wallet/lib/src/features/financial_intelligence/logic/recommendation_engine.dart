import 'package:uuid/uuid.dart';
import '../domain/financial_health_model.dart';
import '../domain/recommendation_model.dart';

class RecommendationEngine {
  static const _uuid = Uuid();

  static List<FinancialRecommendation> generateRecommendations({
    required CreditHealthScore creditScore,
    required double walletBalance,
    required double totalBnplDue,
  }) {
    final List<FinancialRecommendation> recommendations = [];

    // 1. Risk-based Recommendations
    if (creditScore.riskTier == RiskTier.critical ||
        creditScore.riskTier == RiskTier.high) {
      recommendations.add(FinancialRecommendation(
        id: _uuid.v4(),
        title: "Credit Score Alert",
        description:
            "Your credit health is declining due to missed payments or high utilization.",
        impactAnalysis:
            "Improving this can unlock higher BNPL limits (+50% limit possible).",
        type: RecommendationType.warning,
        actionRoute: '/bnpl', // Direct user to BNPL to pay off
      ));
    }

    // 2. Liquidity Recommendations
    if (walletBalance > totalBnplDue * 3 && totalBnplDue > 0) {
      recommendations.add(FinancialRecommendation(
        id: _uuid.v4(),
        title: "Optimize Cash Flow",
        description:
            "You have enough cash to clear all BNPL debts immediately.",
        impactAnalysis:
            "Clearing this debt will boost your Credit Score by approx. 15 points.",
        type: RecommendationType.optimization,
        actionRoute: '/bnpl',
      ));
    }

    // 3. Savings/Investment Recommendations
    if (walletBalance > 10000) {
      recommendations.add(FinancialRecommendation(
        id: _uuid.v4(),
        title: "Idle Cash Detected",
        description:
            "A significant portion of your wallet balance is sitting idle.",
        impactAnalysis: "Investing 50% of this could generate passive returns.",
        type: RecommendationType.insight,
      ));
    }

    // 4. BNPL Usage Warning
    if (totalBnplDue > walletBalance) {
      recommendations.add(FinancialRecommendation(
        id: _uuid.v4(),
        title: "Over-leverage Limit",
        description:
            "Your pending payments exceed your current wallet balance.",
        impactAnalysis:
            "High risk of default. Strongly advise reducing spending immediately.",
        type: RecommendationType.warning,
      ));
    }

    return recommendations;
  }
}
