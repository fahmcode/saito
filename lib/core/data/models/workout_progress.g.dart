// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutProgressAdapter extends TypeAdapter<WorkoutProgress> {
  @override
  final int typeId = 1;

  @override
  WorkoutProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutProgress(
      currentDay: fields[0] as int,
      streak: fields[1] as int,
      lastWorkoutDate: fields[2] as DateTime,
      hasSetBaseline: fields[5] as bool,
      startDate: fields[6] as DateTime?,
      dailyVolume: (fields[3] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as int, (v as List).cast<int>())),
      baselineReps: (fields[4] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutProgress obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.currentDay)
      ..writeByte(1)
      ..write(obj.streak)
      ..writeByte(2)
      ..write(obj.lastWorkoutDate)
      ..writeByte(3)
      ..write(obj.dailyVolume)
      ..writeByte(4)
      ..write(obj.baselineReps)
      ..writeByte(5)
      ..write(obj.hasSetBaseline)
      ..writeByte(6)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
