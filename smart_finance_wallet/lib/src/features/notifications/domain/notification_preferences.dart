import 'package:hive/hive.dart';

part 'notification_preferences.g.dart';

@HiveType(typeId: 5) // Assigning a new unique TypeId
class NotificationPreferences {
  @HiveField(0)
  final bool bnplDueDates;

  @HiveField(1)
  final bool transactions;

  @HiveField(2)
  final bool rewards;

  @HiveField(3)
  final bool budgetAlerts;

  const NotificationPreferences({
    this.bnplDueDates = true,
    this.transactions = true,
    this.rewards = true,
    this.budgetAlerts = true,
  });

  NotificationPreferences copyWith({
    bool? bnplDueDates,
    bool? transactions,
    bool? rewards,
    bool? budgetAlerts,
  }) {
    return NotificationPreferences(
      bnplDueDates: bnplDueDates ?? this.bnplDueDates,
      transactions: transactions ?? this.transactions,
      rewards: rewards ?? this.rewards,
      budgetAlerts: budgetAlerts ?? this.budgetAlerts,
    );
  }
}
