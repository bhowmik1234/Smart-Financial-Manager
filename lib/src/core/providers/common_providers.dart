import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/notification_service.dart';

part 'common_providers.g.dart';

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
