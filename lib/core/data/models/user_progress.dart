import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 0)
class UserProgress extends HiveObject {
  @HiveField(0)
  int currentDay;

  @HiveField(1)
  int streak;

  @HiveField(2)
  DateTime lastWorkoutDate;

  @HiveField(3)
  Map<int, List<int>> dailyVolume; // Day -> [Set1, Set2, ...]

  @HiveField(4)
  Map<String, int> baselineReps; // ExerciseType/Id -> reps

  @HiveField(5)
  bool hasSetBaseline;

  @HiveField(6)
  bool audioEnabled;

  @HiveField(7)
  bool hapticsEnabled;

  @HiveField(8)
  bool securityEnabled;

  @HiveField(9)
  String? securityPin;

  @HiveField(10)
  bool biometricEnabled;

  @HiveField(11)
  int lockDurationMinutes; // 0 for immediate

  @HiveField(12)
  String themeMode; // 'system', 'light', 'dark'

  UserProgress({
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
    Map<int, List<int>>? dailyVolume,
    Map<String, int>? baselineReps,
  }) : dailyVolume = dailyVolume ?? {},
       baselineReps =
           baselineReps ?? {'armor': 20, 'foundation': 20, 'shred': 10};

  // Rank logic
  String get rank {
    if (currentDay <= 5) return "Human";
    if (currentDay <= 25) return "C-Class Hero";
    if (currentDay <= 50) return "B-Class Hero";
    if (currentDay <= 75) return "S-Class Hero";
    return "Special Grade Sorcerer";
  }

  bool get canWorkoutToday {
    final now = DateTime.now();
    return lastWorkoutDate.year < now.year ||
        lastWorkoutDate.month < now.month ||
        lastWorkoutDate.day < now.day;
  }
}
