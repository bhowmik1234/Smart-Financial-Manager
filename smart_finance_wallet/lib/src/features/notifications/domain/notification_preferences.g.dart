// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferencesAdapter
    extends TypeAdapter<NotificationPreferences> {
  @override
  final int typeId = 4;

  @override
  NotificationPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferences(
      bnplDueDates: fields[0] as bool,
      transactions: fields[1] as bool,
      rewards: fields[2] as bool,
      budgetAlerts: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferences obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bnplDueDates)
      ..writeByte(1)
      ..write(obj.transactions)
      ..writeByte(2)
      ..write(obj.rewards)
      ..writeByte(3)
      ..write(obj.budgetAlerts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
