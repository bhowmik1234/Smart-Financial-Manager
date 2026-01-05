// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bnpl_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BnplTransactionAdapter extends TypeAdapter<BnplTransaction> {
  @override
  final int typeId = 2;

  @override
  BnplTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BnplTransaction(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      dueDate: fields[3] as DateTime,
      isPaid: fields[4] as bool,
      createdAt: fields[5] as DateTime,
      paidDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BnplTransaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.isPaid)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.paidDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BnplTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
