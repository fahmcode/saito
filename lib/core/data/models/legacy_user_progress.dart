import 'package:hive/hive.dart';

/// Legacy model kept only for migration purposes.
class LegacyUserProgress extends HiveObject {
  int currentDay;
  int streak;
  DateTime lastWorkoutDate;
  Map<int, List<int>> dailyVolume;
  Map<String, int> baselineReps;
  bool hasSetBaseline;
  bool audioEnabled;
  bool hapticsEnabled;
  bool securityEnabled;
  String? securityPin;
  bool biometricEnabled;
  int lockDurationMinutes;
  String themeMode;
  DateTime? startDate;

  LegacyUserProgress({
    this.currentDay = 1,
    this.streak = 0,
    required this.lastWorkoutDate,
    this.hasSetBaseline = false,
    this.audioEnabled = true,
    this.hapticsEnabled = true,
    this.securityEnabled = false,
    this.biometricEnabled = false,
    this.securityPin,
    this.lockDurationMinutes = 0,
    this.themeMode = 'system',
    this.startDate,
    Map<int, List<int>>? dailyVolume,
    Map<String, int>? baselineReps,
  }) : dailyVolume = dailyVolume ?? {},
       baselineReps =
           baselineReps ?? {'armor': 20, 'foundation': 20, 'shred': 10};
}

/// Manual adapter to avoid build_runner conflict with new model names.
class LegacyUserProgressAdapter extends TypeAdapter<LegacyUserProgress> {
  @override
  final int typeId;

  LegacyUserProgressAdapter(this.typeId);

  @override
  LegacyUserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LegacyUserProgress(
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
      startDate: fields[13] as DateTime?,
      dailyVolume: (fields[3] as Map?)?.map(
        (dynamic k, dynamic v) => MapEntry(k as int, (v as List).cast<int>()),
      ),
      baselineReps: (fields[4] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, LegacyUserProgress obj) {
    // We only need to read, but we provide write just in case.
    writer
      ..writeByte(14)
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
      ..write(obj.themeMode)
      ..writeByte(13)
      ..write(obj.startDate);
  }
}
