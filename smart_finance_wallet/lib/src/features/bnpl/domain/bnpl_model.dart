import 'package:hive/hive.dart';

part 'bnpl_model.g.dart';

@HiveType(typeId: 2)
class BnplTransaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  bool isPaid;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  DateTime? paidDate;

  BnplTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    required this.createdAt,
    this.paidDate,
  });
}
