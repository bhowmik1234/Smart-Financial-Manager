import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/wallet_repository.dart';
import '../domain/transaction_model.dart';
import 'package:smart_finance_wallet/src/core/services/notification_service.dart';
import 'package:smart_finance_wallet/src/features/rewards/presentation/rewards_providers.dart';
import 'package:smart_finance_wallet/src/core/providers/common_providers.dart';
import '../../notifications/presentation/notification_controller.dart';

part 'wallet_providers.g.dart';

// Repositories
@riverpod
WalletRepository walletRepository(WalletRepositoryRef ref) {
  return WalletRepository();
}

// NotificationService moved to core/providers/common_providers.dart

// Logic - Balance Notifier
@riverpod
class Balance extends _$Balance {
  @override
  double build() {
    final repository = ref.watch(walletRepositoryProvider);
    return repository.getBalance();
  }

  Future<void> updateBalance(double newBalance) async {
    final repository = ref.read(walletRepositoryProvider);
    await repository.updateBalance(newBalance);
    state = newBalance;
  }

  void refresh() {
    final repository = ref.read(walletRepositoryProvider);
    state = repository.getBalance();
  }
}

// Logic - Transactions Notifier
@riverpod
class TransactionList extends _$TransactionList {
  @override
  List<Transaction> build() {
    final repository = ref.watch(walletRepositoryProvider);
    return repository.getTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final repository = ref.read(walletRepositoryProvider);
    await repository.addTransaction(transaction);

    // Update balance logic
    final currentBalance = ref.read(balanceProvider);
    double newBalance = currentBalance;
    if (transaction.type == TransactionType.add ||
        transaction.type == TransactionType.receive) {
      newBalance += transaction.amount;
    } else if (transaction.type == TransactionType.send) {
      newBalance -= transaction.amount;
    }
    await ref.read(balanceProvider.notifier).updateBalance(newBalance);

    // Rewards Logic
    if (transaction.type == TransactionType.send) {
      final coins = (transaction.amount / 10).floor();
      if (coins > 0) {
        await ref.read(rewardsControllerProvider.notifier).earnCoins(
              amount: coins,
              reason: 'Spent \$${transaction.amount.toStringAsFixed(0)}',
            );
      }
    }

    // Refresh transactions list
    state = repository.getTransactions();

    // Show Notification via Controller (respects preferences)
    final notificationController = ref.read(notificationControllerProvider);
    // Determine description based on type
    String desc = transaction.type.name.toUpperCase();
    if (transaction.type == TransactionType.send) {
      desc =
          'Merchant/Receiver'; // Simplified for now as we don't have receiver name in Transaction model yet or it's just 'general'
    }
    notificationController.notifyTransaction(desc, transaction.amount);
  }
}
