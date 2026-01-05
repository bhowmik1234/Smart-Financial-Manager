import 'package:flutter/material.dart';
import '../../domain/financial_health_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CreditHealthGauge extends StatelessWidget {
  final CreditHealthScore score;

  const CreditHealthGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    Color gaugeColor;
    switch (score.riskTier) {
      case RiskTier.low:
        gaugeColor = Colors.greenAccent;
        break;
      case RiskTier.medium:
        gaugeColor = Colors.orangeAccent;
        break;
      case RiskTier.high:
        gaugeColor = Colors.deepOrangeAccent;
        break;
      case RiskTier.critical:
        gaugeColor = Colors.redAccent;
        break;
    }

    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: score.score / 100,
                strokeWidth: 12,
                backgroundColor: Colors.white10,
                color: gaugeColor,
                strokeCap: StrokeCap.round,
              ).animate().fadeIn(duration: 1000.ms),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.score}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Outfit',
                      ),
                    )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.easeOutBack),
                    Text(
                      'Outstanding', // This should be dynamic based on score range
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: gaugeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: gaugeColor.withOpacity(0.5))),
          child: Text(
            score.riskTier.name.toUpperCase(),
            style: TextStyle(
              color: gaugeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
