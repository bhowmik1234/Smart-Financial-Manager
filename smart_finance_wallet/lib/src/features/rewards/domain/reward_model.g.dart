// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardTransactionAdapter extends TypeAdapter<RewardTransaction> {
  @override
  final int typeId = 3;

  @override
  RewardTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardTransaction(
      id: fields[0] as String,
      amount: fields[1] as int,
      description: fields[2] as String,
      timestamp: fields[3] as DateTime,
      isCredit: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RewardTransaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.isCredit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
