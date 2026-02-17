import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/engine/workout_engine.dart' as engine;

// ── State ──────────────────────────────────────────────────

enum SessionPhase { exercising, resting, completed }

class WorkoutSessionState extends Equatable {
  final List<engine.Exercise> exercises;
  final int currentExerciseIndex;
  final int currentSet;
  final SessionPhase phase;
  final int restSecondsRemaining;
  final int restTotalSeconds;
  final List<int> completedVolumes;
  final int day;

  const WorkoutSessionState({
    required this.exercises,
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.phase = SessionPhase.exercising,
    this.restSecondsRemaining = 0,
    this.restTotalSeconds = 0,
    this.completedVolumes = const [],
    required this.day,
  });

  engine.Exercise get currentExercise => exercises[currentExerciseIndex];

  engine.Exercise? get nextExercise {
    if (currentExerciseIndex < exercises.length - 1) {
      return exercises[currentExerciseIndex + 1];
    }
    return null;
  }

  bool get isLastExercise => currentExerciseIndex == exercises.length - 1;
  bool get isLastSet => currentSet == currentExercise.sets;
  bool get isLast => isLastExercise && isLastSet;

  WorkoutSessionState copyWith({
    List<engine.Exercise>? exercises,
    int? currentExerciseIndex,
    int? currentSet,
    SessionPhase? phase,
    int? restSecondsRemaining,
    int? restTotalSeconds,
    List<int>? completedVolumes,
    int? day,
  }) {
    return WorkoutSessionState(
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      phase: phase ?? this.phase,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      restTotalSeconds: restTotalSeconds ?? this.restTotalSeconds,
      completedVolumes: completedVolumes ?? this.completedVolumes,
      day: day ?? this.day,
    );
  }

  @override
  List<Object?> get props => [
    currentExerciseIndex,
    currentSet,
    phase,
    restSecondsRemaining,
    restTotalSeconds,
    completedVolumes,
    day,
  ];
}

// ── Cubit ──────────────────────────────────────────────────

class WorkoutSessionCubit extends Cubit<WorkoutSessionState> {
  Timer? _restTimer;

  WorkoutSessionCubit({
    required int day,
    required Map<String, int> baselineReps,
  }) : super(
         WorkoutSessionState(
           day: day,
           exercises: engine.WorkoutEngine.getExercisesForDay(
             day,
             baselineReps,
           ),
         ),
       );

  void completeSet() {
    final s = state;
    final restSeconds = engine.WorkoutEngine.getRestDuration(s.day).inSeconds;

    // Record volume for this set
    final volumes = List<int>.from(s.completedVolumes)
      ..add(s.currentExercise.baseReps);

    if (s.isLast) {
      // Workout complete
      emit(
        s.copyWith(phase: SessionPhase.completed, completedVolumes: volumes),
      );
      return;
    }

    // Move to next set or next exercise
    int nextExerciseIndex = s.currentExerciseIndex;
    int nextSet = s.currentSet;

    if (s.currentSet < s.currentExercise.sets) {
      nextSet = s.currentSet + 1;
    } else {
      nextExerciseIndex = s.currentExerciseIndex + 1;
      nextSet = 1;
    }

    emit(
      s.copyWith(
        currentExerciseIndex: nextExerciseIndex,
        currentSet: nextSet,
        phase: SessionPhase.resting,
        restSecondsRemaining: restSeconds,
        restTotalSeconds: restSeconds,
        completedVolumes: volumes,
      ),
    );

    _startRestTimer();
  }

  void skipRest() {
    _restTimer?.cancel();
    emit(
      state.copyWith(phase: SessionPhase.exercising, restSecondsRemaining: 0),
    );
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.restSecondsRemaining - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(
          state.copyWith(
            phase: SessionPhase.exercising,
            restSecondsRemaining: 0,
          ),
        );
      } else {
        emit(state.copyWith(restSecondsRemaining: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _restTimer?.cancel();
    return super.close();
  }
}
