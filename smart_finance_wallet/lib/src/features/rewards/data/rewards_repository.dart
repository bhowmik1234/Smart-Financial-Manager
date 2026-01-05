import 'package:hive_flutter/hive_flutter.dart';
import '../domain/reward_model.dart';

class RewardsRepository {
  static const String metaBoxName = 'rewards_meta';
  static const String historyBoxName = 'rewards_history';
  static const String balanceKey = 'coin_balance';

  Future<void> init() async {
    await Hive.openBox(metaBoxName);
    await Hive.openBox<RewardTransaction>(historyBoxName);
  }

  Box get _metaBox => Hive.box(metaBoxName);
  Box<RewardTransaction> get _historyBox =>
      Hive.box<RewardTransaction>(historyBoxName);

  int getBalance() {
    return _metaBox.get(balanceKey, defaultValue: 0) as int;
  }

  Future<void> _updateBalance(int newBalance) async {
    await _metaBox.put(balanceKey, newBalance);
  }

  List<RewardTransaction> getHistory() {
    return _historyBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> addTransaction({
    required int amount,
    required String description,
    required bool isCredit,
  }) async {
    final currentBalance = getBalance();
    final newBalance =
        isCredit ? currentBalance + amount : currentBalance - amount;

    // Allow negative balance? probably not for redemption, but we check that in provider
    await _updateBalance(newBalance);

    final transaction = RewardTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      description: description,
      timestamp: DateTime.now(),
      isCredit: isCredit,
    );

    await _historyBox.add(transaction);
  }
}
