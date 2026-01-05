// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
      description: fields[3] as String,
      type: fields[4] as TransactionType,
      category: fields[5] as TransactionCategory,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 0;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.send;
      case 1:
        return TransactionType.receive;
      case 2:
        return TransactionType.add;
      default:
        return TransactionType.send;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.send:
        writer.writeByte(0);
        break;
      case TransactionType.receive:
        writer.writeByte(1);
        break;
      case TransactionType.add:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = 4;

  @override
  TransactionCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionCategory.food;
      case 1:
        return TransactionCategory.travel;
      case 2:
        return TransactionCategory.bills;
      case 3:
        return TransactionCategory.shopping;
      case 4:
        return TransactionCategory.entertainment;
      case 5:
        return TransactionCategory.health;
      case 6:
        return TransactionCategory.education;
      case 7:
        return TransactionCategory.salary;
      case 8:
        return TransactionCategory.investment;
      case 9:
        return TransactionCategory.general;
      default:
        return TransactionCategory.food;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionCategory obj) {
    switch (obj) {
      case TransactionCategory.food:
        writer.writeByte(0);
        break;
      case TransactionCategory.travel:
        writer.writeByte(1);
        break;
      case TransactionCategory.bills:
        writer.writeByte(2);
        break;
      case TransactionCategory.shopping:
        writer.writeByte(3);
        break;
      case TransactionCategory.entertainment:
        writer.writeByte(4);
        break;
      case TransactionCategory.health:
        writer.writeByte(5);
        break;
      case TransactionCategory.education:
        writer.writeByte(6);
        break;
      case TransactionCategory.salary:
        writer.writeByte(7);
        break;
      case TransactionCategory.investment:
        writer.writeByte(8);
        break;
      case TransactionCategory.general:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
