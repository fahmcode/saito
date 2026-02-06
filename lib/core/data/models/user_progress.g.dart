// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 0;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      currentDay: fields[0] as int,
      streak: fields[1] as int,
      lastWorkoutDate: fields[2] as DateTime,
      hasSetBaseline: fields[5] as bool,
      audioEnabled: fields[6] as bool,
      hapticsEnabled: fields[7] as bool,
      securityEnabled: fields[8] as bool,
      biometricEnabled: fields[10] as bool,
      securityPin: fields[9] as String?,
      lockDurationMinutes: fields[11] as int,
      themeMode: fields[12] as String,
      dailyVolume: (fields[3] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as int, (v as List).cast<int>())),
      baselineReps: (fields[4] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.audioEnabled)
      ..writeByte(7)
      ..write(obj.hapticsEnabled)
      ..writeByte(8)
      ..write(obj.securityEnabled)
      ..writeByte(9)
      ..write(obj.securityPin)
      ..writeByte(10)
      ..write(obj.biometricEnabled)
      ..writeByte(11)
      ..write(obj.lockDurationMinutes)
      ..writeByte(12)
      ..write(obj.themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
