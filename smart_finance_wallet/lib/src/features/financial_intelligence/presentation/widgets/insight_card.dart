import 'package:flutter/material.dart';
import '../../domain/recommendation_model.dart';
import 'package:go_router/go_router.dart';

class InsightCard extends StatelessWidget {
  final FinancialRecommendation recommendation;

  const InsightCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (recommendation.type) {
      case RecommendationType.warning:
        color = Colors.redAccent;
        icon = Icons.warning_rounded;
        break;
      case RecommendationType.optimization:
        color = Colors.blueAccent;
        icon = Icons.insights_rounded;
        break;
      case RecommendationType.insight:
        color = Colors.purpleAccent;
        icon = Icons.lightbulb_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          recommendation.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          recommendation.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        childrenPadding: const EdgeInsets.all(16),
        collapsedIconColor: Colors.white54,
        iconColor: color,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ANALYSIS',
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation.impactAnalysis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              if (recommendation.actionRoute != null)
                TextButton(
                  onPressed: () {
                    context.push(recommendation.actionRoute!);
                  },
                  child: Text(
                    'TAKE ACTION',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
