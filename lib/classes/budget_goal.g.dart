// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetGoalAdapter extends TypeAdapter<BudgetGoal> {
  @override
  final int typeId = 5;

  @override
  BudgetGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetGoal(
      id: fields[0] as String,
      name: fields[1] as String,
      status: fields[2] as GoalStatus,
      description: fields[3] as String,
      fromDate: fields[4] as DateTime,
      toDate: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetGoal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.fromDate)
      ..writeByte(5)
      ..write(obj.toDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalStatusAdapter extends TypeAdapter<GoalStatus> {
  @override
  final int typeId = 4;

  @override
  GoalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalStatus.ongoing;
      case 1:
        return GoalStatus.achieved;
      case 2:
        return GoalStatus.failed;
      default:
        return GoalStatus.ongoing;
    }
  }

  @override
  void write(BinaryWriter writer, GoalStatus obj) {
    switch (obj) {
      case GoalStatus.ongoing:
        writer.writeByte(0);
        break;
      case GoalStatus.achieved:
        writer.writeByte(1);
        break;
      case GoalStatus.failed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
