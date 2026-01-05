import 'package:flutter/foundation.dart';

enum RecommendationType {
  warning, // High importance, risk related
  optimization, // Medium importance, better usage
  insight, // Info only
}

@immutable
class FinancialRecommendation {
  final String id;
  final String title;
  final String description;
  final String impactAnalysis; // "This will save you $X"
  final RecommendationType type;
  final String? actionRoute; // e.g., '/bnpl'

  const FinancialRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.impactAnalysis,
    required this.type,
    this.actionRoute,
  });
}
