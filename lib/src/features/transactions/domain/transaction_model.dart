import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  send,
  @HiveField(1)
  receive,
  @HiveField(2)
  add,
}

@HiveType(typeId: 4)
enum TransactionCategory {
  @HiveField(0)
  food,
  @HiveField(1)
  travel,
  @HiveField(2)
  bills,
  @HiveField(3)
  shopping,
  @HiveField(4)
  entertainment,
  @HiveField(5)
  health,
  @HiveField(6)
  education,
  @HiveField(7)
  salary,
  @HiveField(8)
  investment,
  @HiveField(9)
  general,
}

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final TransactionType type;

  @HiveField(5)
  final TransactionCategory category;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
    this.category = TransactionCategory.general,
  });
}
