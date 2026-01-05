import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/rewards_repository.dart';
import '../domain/reward_model.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/common_providers.dart';
import '../../notifications/presentation/notification_controller.dart';

part 'rewards_providers.g.dart';

@riverpod
RewardsRepository rewardsRepository(RewardsRepositoryRef ref) {
  return RewardsRepository();
}

@riverpod
class CoinBalance extends _$CoinBalance {
  @override
  int build() {
    final repository = ref.watch(rewardsRepositoryProvider);
    return repository.getBalance();
  }

  Future<void> refresh() async {
    final repository = ref.read(rewardsRepositoryProvider);
    state = repository.getBalance();
  }
}

@riverpod
class RewardsHistory extends _$RewardsHistory {
  @override
  List<RewardTransaction> build() {
    final repository = ref.watch(rewardsRepositoryProvider);
    return repository.getHistory();
  }

  void refresh() {
    final repository = ref.read(rewardsRepositoryProvider);
    state = repository.getHistory();
  }
}

@riverpod
class RewardsController extends _$RewardsController {
  @override
  void build() {}

  Future<void> earnCoins({required int amount, required String reason}) async {
    final repository = ref.read(rewardsRepositoryProvider);
    await repository.addTransaction(
      amount: amount,
      description: reason,
      isCredit: true,
    );

    // Refresh state
    ref.invalidate(coinBalanceProvider);
    ref.invalidate(rewardsHistoryProvider);

    // Show Notification via Controller (respects preferences)
    final notificationController = ref.read(notificationControllerProvider);
    notificationController.notifyRewardEarned(amount);
  }

  Future<bool> redeemCoins({required int amount, required String item}) async {
    final repository = ref.read(rewardsRepositoryProvider);
    final currentBalance = repository.getBalance();

    if (currentBalance >= amount) {
      await repository.addTransaction(
        amount: amount,
        description: 'Redeemed for $item',
        isCredit: false,
      );

      // Refresh state
      ref.invalidate(coinBalanceProvider);
      ref.invalidate(rewardsHistoryProvider);
      return true;
    }
    return false;
  }
}
