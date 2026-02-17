import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/data/models/workout_progress.dart';
import 'package:saito/core/data/repositories/app_repository.dart';

// ── State ──────────────────────────────────────────────────

class WorkoutState extends Equatable {
  final WorkoutProgress progress;

  const WorkoutState(this.progress);

  @override
  List<Object?> get props => [
    progress.currentDay,
    progress.streak,
    progress.lastWorkoutDate,
    progress.hasSetBaseline,
    progress.startDate,
    progress.dailyVolume,
    progress.baselineReps,
  ];
}

// ── Cubit ──────────────────────────────────────────────────

class WorkoutCubit extends Cubit<WorkoutState> {
  final AppRepository _repo;

  WorkoutCubit(this._repo)
    : super(WorkoutState(WorkoutProgress(lastWorkoutDate: DateTime(2000))));

  Future<void> load() async {
    final progress = await _repo.getWorkout();
    emit(WorkoutState(progress));
  }

  void completeDay({required int day, required List<int> volume}) {
    final current = state.progress;
    final updatedVolume = Map<int, List<int>>.from(current.dailyVolume);
    updatedVolume[day] = volume;

    final updated = current.copyWith(
      currentDay: current.currentDay + 1,
      streak: current.streak + 1,
      lastWorkoutDate: DateTime.now(),
      dailyVolume: updatedVolume,
      startDate: current.startDate ?? DateTime.now(),
    );

    _repo.saveWorkout(updated);
    HapticFeedback.heavyImpact();
    emit(WorkoutState(updated));
  }

  void saveBaselineReps(Map<String, int> reps) {
    final updated = state.progress.copyWith(
      baselineReps: reps,
      hasSetBaseline: true,
    );
    _repo.saveWorkout(updated);
    emit(WorkoutState(updated));
  }

  void resetProgress() {
    final fresh = WorkoutProgress(lastWorkoutDate: DateTime(2000));
    _repo.saveWorkout(fresh);
    emit(WorkoutState(fresh));
  }
}
