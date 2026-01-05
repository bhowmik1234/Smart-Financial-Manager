import 'package:hive_flutter/hive_flutter.dart';
import '../domain/notification_preferences.dart';

class PreferencesRepository {
  static const String boxName = 'preferences_box';
  static const String key = 'notification_settings';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<NotificationPreferences>(boxName);
    }
  }

  NotificationPreferences loadPreferences() {
    final box = Hive.box<NotificationPreferences>(boxName);
    return box.get(key) ?? const NotificationPreferences();
  }

  Future<void> savePreferences(NotificationPreferences preferences) async {
    final box = Hive.box<NotificationPreferences>(boxName);
    await box.put(key, preferences);
  }
}
