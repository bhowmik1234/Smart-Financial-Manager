import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/bnpl_repository.dart';
import '../domain/bnpl_model.dart';
import '../../../core/services/notification_service.dart';
import '../../rewards/presentation/rewards_providers.dart';
import '../../../core/providers/common_providers.dart';
import '../../notifications/presentation/notification_controller.dart';

part 'bnpl_providers.g.dart';

@riverpod
BnplRepository bnplRepository(BnplRepositoryRef ref) {
  return BnplRepository();
}

@riverpod
class BnplTransactions extends _$BnplTransactions {
  @override
  List<BnplTransaction> build() {
    final repository = ref.watch(bnplRepositoryProvider);
    return repository.getTransactions();
  }

  Future<void> addTransaction(BnplTransaction transaction) async {
    final repository = ref.read(bnplRepositoryProvider);
    await repository.addTransaction(transaction);

    // Schedule Notification via Controller (respects preferences)
    final notificationController = ref.read(notificationControllerProvider);

    if (transaction.dueDate.isAfter(DateTime.now())) {
      notificationController.scheduleBnplReminder(
          transaction.id, transaction.title, transaction.dueDate);
    }

    state = repository.getTransactions();
  }

  Future<void> markAsPaid(String id) async {
    final repository = ref.read(bnplRepositoryProvider);
    await repository.markAsPaid(id);

    // Cancel Notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.cancelNotification(id.hashCode);

    state = repository.getTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    final repository = ref.read(bnplRepositoryProvider);
    await repository.deleteTransaction(id);

    // Cancel Notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.cancelNotification(id.hashCode);

    state = repository.getTransactions();
  }
}
