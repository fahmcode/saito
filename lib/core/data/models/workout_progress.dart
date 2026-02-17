import 'package:hive/hive.dart';

part 'workout_progress.g.dart';

@HiveType(typeId: 1)
class WorkoutProgress extends HiveObject {
  @HiveField(0)
  int currentDay;

  @HiveField(1)
  int streak;

  @HiveField(2)
  DateTime lastWorkoutDate;

  @HiveField(3)
  Map<int, List<int>> dailyVolume;

  @HiveField(4)
  Map<String, int> baselineReps;

  @HiveField(5)
  bool hasSetBaseline;

  @HiveField(6)
  DateTime? startDate;

  WorkoutProgress({
    this.currentDay = 1,
    this.streak = 0,
    required this.lastWorkoutDate,
    this.hasSetBaseline = false,
    this.startDate,
    Map<int, List<int>>? dailyVolume,
    Map<String, int>? baselineReps,
  }) : dailyVolume = dailyVolume ?? {},
       baselineReps =
           baselineReps ?? {'armor': 20, 'foundation': 20, 'shred': 10};

  WorkoutProgress copyWith({
    int? currentDay,
    int? streak,
    DateTime? lastWorkoutDate,
    Map<int, List<int>>? dailyVolume,
    Map<String, int>? baselineReps,
    bool? hasSetBaseline,
    DateTime? startDate,
  }) {
    return WorkoutProgress(
      currentDay: currentDay ?? this.currentDay,
      streak: streak ?? this.streak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      dailyVolume: dailyVolume ?? this.dailyVolume,
      baselineReps: baselineReps ?? this.baselineReps,
      hasSetBaseline: hasSetBaseline ?? this.hasSetBaseline,
      startDate: startDate ?? this.startDate,
    );
  }

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
