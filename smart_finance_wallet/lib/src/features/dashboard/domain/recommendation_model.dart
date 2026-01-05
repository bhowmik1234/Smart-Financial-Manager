import 'package:flutter/material.dart';

enum RecommendationType {
  savings,
  spending,
  credit,
  reward,
}

enum RecommendationSeverity {
  info,
  warning,
  critical,
}

enum ActionType {
  payBnpl,
  viewSpending,
  viewRewards,
  none,
}

class Recommendation {
  final String id;
  final String title;
  final String description;
  final RecommendationType type;
  final RecommendationSeverity severity;
  final ActionType actionType;
  final Map<String, dynamic>? actionData;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    this.actionType = ActionType.none,
    this.actionData,
  });

  Color get color {
    switch (severity) {
      case RecommendationSeverity.info:
        return Colors.blue;
      case RecommendationSeverity.warning:
        return Colors.orange;
      case RecommendationSeverity.critical:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (type) {
      case RecommendationType.savings:
        return Icons.savings;
      case RecommendationType.spending:
        return Icons.analytics;
      case RecommendationType.credit:
        return Icons.credit_score;
      case RecommendationType.reward:
        return Icons.stars;
    }
  }
}
