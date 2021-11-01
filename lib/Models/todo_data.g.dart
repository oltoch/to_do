// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoDataAdapter extends TypeAdapter<TodoData> {
  @override
  final int typeId = 0;

  @override
  TodoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoData()
      ..title = fields[0] as String
      ..dateStarted = fields[1] as DateTime
      ..timeStarted = fields[2] as String
      ..isAlarmOn = fields[3] as bool
      ..isCompleted = fields[4] as bool
      ..dateExpected = fields[5] as DateTime
      ..dateCompleted = fields[6] as DateTime?
      ..timeExpected = fields[7] as String
      ..timeCompleted = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, TodoData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.dateStarted)
      ..writeByte(2)
      ..write(obj.timeStarted)
      ..writeByte(3)
      ..write(obj.isAlarmOn)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.dateExpected)
      ..writeByte(6)
      ..write(obj.dateCompleted)
      ..writeByte(7)
      ..write(obj.timeExpected)
      ..writeByte(8)
      ..write(obj.timeCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
