import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'wallet_providers.dart';
import '../domain/transaction_model.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  bool _isLoading = false;
  TransactionCategory _selectedCategory = TransactionCategory.general;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  void _sendMoney() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (_recipientController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipient')),
      );
      return;
    }

    // Check balance
    final currentBalance = ref.read(balanceProvider);
    if (amount > currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient funds')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tx = Transaction(
        id: const Uuid().v4(),
        amount: amount,
        date: DateTime.now(),
        description: 'Sent to ${_recipientController.text}',
        type: TransactionType.send,
        category: _selectedCategory,
      );

      await ref.read(transactionListProvider.notifier).addTransaction(tx);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient (Email or Phone)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TransactionCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: TransactionCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: _sendMoney,
                      child: const Text('Send Funds'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
