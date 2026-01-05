import 'package:hive/hive.dart';

part 'reward_model.g.dart';

@HiveType(typeId: 3)
class RewardTransaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isCredit; // true for earn, false for redeem

  RewardTransaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.isCredit,
  });
}
