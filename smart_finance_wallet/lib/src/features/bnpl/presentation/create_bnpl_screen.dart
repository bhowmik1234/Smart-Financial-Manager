import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../domain/bnpl_model.dart';
import 'bnpl_providers.dart';

class CreateBnplTransactionScreen extends ConsumerStatefulWidget {
  const CreateBnplTransactionScreen({super.key});

  @override
  ConsumerState<CreateBnplTransactionScreen> createState() =>
      _CreateBnplTransactionScreenState();
}

class _CreateBnplTransactionScreenState
    extends ConsumerState<CreateBnplTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final title = _titleController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      final transaction = BnplTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        dueDate: _selectedDate!,
        createdAt: DateTime.now(),
      );

      await ref
          .read(bnplTransactionsProvider.notifier)
          .addTransaction(transaction);

      if (mounted) {
        context.pop();
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add BNPL Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Title / Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Select Due Date'
                      : 'Due: ${DateFormat('MMM dd, yyyy').format(_selectedDate!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  child: const Text('Save Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
