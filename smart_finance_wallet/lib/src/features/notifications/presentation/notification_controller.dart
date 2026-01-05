import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../notifications/data/preferences_repository.dart';
import '../../notifications/domain/notification_preferences.dart';
import 'package:smart_finance_wallet/src/core/providers/common_providers.dart';

part 'notification_controller.g.dart';

@riverpod
class NotificationSettings extends _$NotificationSettings {
  late final PreferencesRepository _repository;

  @override
  NotificationPreferences build() {
    _repository = PreferencesRepository();
    // In a real app, repos should be provided via a provider too.
    // For now, simple instantiation is okay as Hive box is singleton-like.
    return _repository.loadPreferences();
  }

  Future<void> toggleBnplDueDates(bool value) async {
    final newPrefs = state.copyWith(bnplDueDates: value);
    state = newPrefs;
    await _repository.savePreferences(newPrefs);
  }

  Future<void> toggleTransactions(bool value) async {
    final newPrefs = state.copyWith(transactions: value);
    state = newPrefs;
    await _repository.savePreferences(newPrefs);
  }

  Future<void> toggleRewards(bool value) async {
    final newPrefs = state.copyWith(rewards: value);
    state = newPrefs;
    await _repository.savePreferences(newPrefs);
  }
}

// Service to trigger notifications checking preferences
final notificationControllerProvider =
    Provider((ref) => NotificationController(ref));

class NotificationController {
  final Ref _ref;

  NotificationController(this._ref);

  void notifyRewardEarned(int amount) {
    final prefs = _ref.read(notificationSettingsProvider);
    if (!prefs.rewards) return;

    _ref.read(notificationServiceProvider).showRewardNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: 'Rewards Earned!',
          body: 'You just earned $amount coins!',
        );
  }

  void notifyTransaction(String description, double amount) {
    final prefs = _ref.read(notificationSettingsProvider);
    if (!prefs.transactions) return;

    _ref.read(notificationServiceProvider).showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: 'Transaction Alert',
          body: 'You spent \$${amount.toStringAsFixed(2)} at $description',
        );
  }

  void scheduleBnplReminder(
      String itemId, String description, DateTime dueDate) {
    final prefs = _ref.read(notificationSettingsProvider);
    if (!prefs.bnplDueDates)
      return; // Note: Toggling off should ideally cancel scheduled ones too.

    _ref.read(notificationServiceProvider).scheduleNotification(
          id: itemId.hashCode,
          title: 'BNPL Payment Due Soon',
          body: 'Your payment for $description is due tomorrow!',
          scheduledDate: dueDate.subtract(const Duration(days: 1)),
        );
  }
}
