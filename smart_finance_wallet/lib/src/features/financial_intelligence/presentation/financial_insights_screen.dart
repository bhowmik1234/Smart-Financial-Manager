import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_finance_wallet/src/core/presentation/widgets/glass_card.dart';
import 'financial_intelligence_providers.dart';
import 'widgets/credit_health_gauge.dart';
import 'widgets/simulation_slider.dart';
import 'widgets/insight_card.dart';
import '../domain/financial_health_model.dart';

class FinancialInsightsScreen extends ConsumerWidget {
  const FinancialInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditScore = ref.watch(creditHealthProvider);
    final spendingDna = ref.watch(spendingDnaProvider);
    final recommendations = ref.watch(recommendationsProvider);
    final simulationScenario = ref.watch(simulationScenarioProvider);
    final simulationResult = ref.watch(simulationResultProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Financial Intelligence'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF000000),
              const Color(0xFF1A237E).withOpacity(0.2), // Deep Indigo
              const Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Credit Health Section
                Center(
                  child: CreditHealthGauge(score: creditScore),
                ),
                const SizedBox(height: 24),

                // 2. Spending DNA Badge
                Center(
                  child: _SpendingDnaBadge(dna: spendingDna),
                ),
                const SizedBox(height: 32),

                // 3. Digital Twin / Simulation
                Text(
                  'FINANCIAL DIGITAL TWIN',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  opacity: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('30-Day Projection',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color:
                                      simulationResult.predictedBalance30Days >=
                                              0
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                '\$${simulationResult.predictedBalance30Days.toStringAsFixed(0)}',
                                style: TextStyle(
                                    color: simulationResult
                                                .predictedBalance30Days >=
                                            0
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          simulationResult.outcomeDescription,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                              fontStyle: FontStyle.italic),
                        ),
                        const Divider(color: Colors.white10, height: 32),

                        // Simulation Sliders
                        SimulationSlider(
                          label: 'Monthly Income',
                          value: simulationScenario.monthlyIncome,
                          min: 1000,
                          max: 20000,
                          labelFormatter: (v) => '\$${v.toInt()}',
                          onChanged: (val) {
                            ref
                                .read(simulationScenarioProvider.notifier)
                                .updateScenario(monthlyIncome: val);
                          },
                        ),
                        SimulationSlider(
                          label: 'Monthly Expenses',
                          value: simulationScenario.monthlyExpenses,
                          min: 500,
                          max: 15000,
                          labelFormatter: (v) => '\$${v.toInt()}',
                          onChanged: (val) {
                            ref
                                .read(simulationScenarioProvider.notifier)
                                .updateScenario(monthlyExpenses: val);
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Simulate Delayed Payment',
                              style: TextStyle(color: Colors.white70)),
                          value: simulationScenario.delayPayment,
                          activeColor: const Color(0xFF651FFF),
                          onChanged: (val) {
                            ref
                                .read(simulationScenarioProvider.notifier)
                                .updateScenario(delayPayment: val);
                          },
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                const SizedBox(height: 32),

                // 4. AI Recommendations
                if (recommendations.isNotEmpty) ...[
                  Text(
                    'AI RECOMMENDATIONS',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 16),
                  ...recommendations
                      .map((rec) => InsightCard(recommendation: rec)),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpendingDnaBadge extends StatelessWidget {
  final SpendingDna dna;

  const _SpendingDnaBadge({required this.dna});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    Color color;

    switch (dna.persona) {
      case SpendingPersona.planner:
        icon = Icons.architecture_rounded;
        title = "The Planner";
        color = Colors.blueAccent;
        break;
      case SpendingPersona.impulseOptimizer:
        icon = Icons.rocket_launch_rounded;
        title = "Impulse Optimizer";
        color = Colors.purpleAccent;
        break;
      case SpendingPersona.stabilitySeeker:
        icon = Icons.shield_rounded;
        title = "Stability Seeker";
        color = Colors.tealAccent;
        break;
      case SpendingPersona.riskTaker:
        icon = Icons.kitesurfing_rounded;
        title = "Risk Taker";
        color = Colors.orangeAccent;
        break;
      default:
        icon = Icons.person_outline;
        title = "Unknown";
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SPENDING DNA',
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    ).animate().fadeIn().scale();
  }
}
