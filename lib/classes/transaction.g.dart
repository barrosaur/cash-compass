// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 2;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      category: fields[1] as Category,
      account: fields[2] as Account,
      amount: fields[3] as double,
      mode: fields[4] as TransactionMode,
      date: fields[5] as DateTime,
      description: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.account)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.mode)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.description);
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

class TransactionModeAdapter extends TypeAdapter<TransactionMode> {
  @override
  final int typeId = 1;

  @override
  TransactionMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionMode.income;
      case 1:
        return TransactionMode.expense;
      default:
        return TransactionMode.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionMode obj) {
    switch (obj) {
      case TransactionMode.income:
        writer.writeByte(0);
        break;
      case TransactionMode.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
