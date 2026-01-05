import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.add ||
        transaction.type == TransactionType.receive;
    final color = isCredit ? Colors.green : Colors.red;
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.description ?? 'Transaction',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          '${isCredit ? '+' : '-'} \$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
