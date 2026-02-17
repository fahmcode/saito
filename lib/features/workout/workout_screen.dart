import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/engine/workout_engine.dart' as engine;
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/core/logic/cubit/workout_session_cubit.dart';
import 'package:saito/features/workout/workout_complete_screen.dart';
import 'package:saito/features/workout/workout_header.dart';
import 'package:saito/features/workout/workout_progress.dart';
import 'package:saito/features/workout/exercise_view.dart';
import 'package:saito/features/workout/rest_view.dart';
import 'package:saito/features/workout/workout_footer.dart';
import 'package:saito/features/workout/recovery_view.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutState = context.read<WorkoutCubit>().state;
    final progress = workoutState.progress;
    final day = progress.currentDay;
    final workoutType = engine.WorkoutEngine.getWorkoutType(day);

    // Recovery day — simple screen
    if (workoutType == engine.WorkoutType.recovery) {
      return RecoveryView(day: day);
    }

    return BlocProvider(
      create: (_) =>
          WorkoutSessionCubit(day: day, baselineReps: progress.baselineReps),
      child: _WorkoutBody(day: day),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Workout Body (uses WorkoutSessionCubit)
// ─────────────────────────────────────────────────────────────

class _WorkoutBody extends StatelessWidget {
  final int day;
  const _WorkoutBody({required this.day});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutSessionCubit, WorkoutSessionState>(
      listenWhen: (prev, curr) =>
          prev.phase != curr.phase && curr.phase == SessionPhase.completed,
      listener: (context, state) {
        _onWorkoutComplete(context, state);
      },
      builder: (context, session) {
        final theme = Theme.of(context);
        final workoutType = engine.WorkoutEngine.getWorkoutType(day);
        final phase = engine.WorkoutEngine.getPhase(day);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _showExitConfirmation(context);
          },
          child: Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  WorkoutHeader(
                    workoutType: workoutType,
                    phase: phase,
                    day: day,
                    onClose: () => _showExitConfirmation(context),
                  ),
                  WorkoutProgress(
                    exercises: session.exercises,
                    currentIndex: session.currentExerciseIndex,
                    currentSet: session.currentSet,
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: DesignSystem.durationMedium,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: session.phase == SessionPhase.resting
                          ? RestView(
                              key: const ValueKey('rest'),
                              seconds: session.restSecondsRemaining,
                              totalSeconds: session.restTotalSeconds,
                            )
                          : ExerciseView(
                              key: ValueKey(
                                'ex_${session.currentExerciseIndex}_${session.currentSet}',
                              ),
                              exercise: session.currentExercise,
                              setNumber: session.currentSet,
                            ),
                    ),
                  ),
                  WorkoutFooter(
                    session: session,
                    onComplete: () =>
                        context.read<WorkoutSessionCubit>().completeSet(),
                    onSkipRest: () =>
                        context.read<WorkoutSessionCubit>().skipRest(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onWorkoutComplete(BuildContext context, WorkoutSessionState session) {
    final workoutCubit = context.read<WorkoutCubit>();
    workoutCubit.completeDay(day: day, volume: session.completedVolumes);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WorkoutCompleteScreen(
          completedDay: day,
          progress: workoutCubit.state.progress,
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Icon(Symbols.warning, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: DesignSystem.spacingL),
              Text(
                'Abandon Workout?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingS),
              Text(
                'All progress in this session will be lost.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('CONTINUE'),
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingM),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                        backgroundColor: theme.colorScheme.error,
                      ),
                      child: const Text('QUIT'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.spacingM),
            ],
          ),
        );
      },
    );
  }
}
