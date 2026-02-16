import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';
import 'package:saito/core/engine/workout_engine.dart' as engine;
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/features/workout/workout_complete_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  final List<int> _completedVolumes = [];
  bool _isResting = false;
  int _secondsRemaining = 0;
  Timer? _timer;
  List<engine.Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    final progress = context.read<UserProgressBloc>().state.progress;
    _exercises = engine.WorkoutEngine.getExercisesForDay(
      progress.currentDay,
      progress.baselineReps,
    );
  }

  void _playSound(String effect) {
    final progress = context.read<UserProgressBloc>().state.progress;
    if (!progress.hapticsEnabled) return;

    try {
      if (effect == 'success') {
        HapticFeedback.heavyImpact();
      } else if (effect == 'tick') {
        HapticFeedback.selectionClick();
      }
    } catch (_) {}
  }

  void _toggleRest(int seconds) {
    _playSound('success');
    setState(() {
      _isResting = true;
      _secondsRemaining = seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (_secondsRemaining <= 3) _playSound('tick');
        setState(() => _secondsRemaining--);
      } else {
        _endRest();
      }
    });
  }

  void _endRest() {
    _timer?.cancel();
    _playSound('success');
    setState(() => _isResting = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onSetComplete(engine.Exercise currentExercise, int restSeconds) {
    if (_currentSet < currentExercise.sets) {
      _toggleRest(restSeconds);
      setState(() => _currentSet++);
    } else if (_currentExerciseIndex < _exercises.length - 1) {
      _toggleRest(restSeconds);
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
      });
    } else {
      _finishWorkout(
        context.read<UserProgressBloc>().state.progress.currentDay,
      );
    }
  }

  void _finishWorkout(int day) {
    _playSound('success');
    context.read<UserProgressBloc>().add(
      CompleteDayEvent(day: day, volume: _completedVolumes),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => WorkoutCompleteScreen(day: day)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = context.watch<UserProgressBloc>().state.progress;
    final workoutType = engine.WorkoutEngine.getWorkoutType(
      progress.currentDay,
    );

    if (workoutType == engine.WorkoutType.recovery) {
      return _buildRecoveryScreen(context);
    }

    if (_exercises.isEmpty) {
      return const Scaffold(body: Center(child: Text('Workout not found.')));
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    final restDuration = engine.WorkoutEngine.getRestDuration(
      progress.currentDay,
    );
    final tempo = engine.WorkoutEngine.getTempo(progress.currentDay);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildWorkoutHeader(
              context,
              _exercises.length,
              _currentExerciseIndex,
            ),

            Expanded(
              child: AnimatedSwitcher(
                duration: 400.ms,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(
                        Tween(
                          begin: const Offset(0.0, 0.05),
                          end: Offset.zero,
                        ).chain(
                          CurveTween(curve: const CurveTwice(Curves.easeOut)),
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: _isResting
                    ? _RestView(
                        key: const ValueKey('rest'),
                        seconds: _secondsRemaining,
                        totalSeconds: restDuration.inSeconds,
                      )
                    : _ExerciseView(
                        key: ValueKey(
                          'exercise_${_currentExerciseIndex}_$_currentSet',
                        ),
                        name: currentExercise.name,
                        reps: currentExercise.baseReps,
                        currentSet: _currentSet,
                        totalSets: currentExercise.sets,
                        description: currentExercise.description,
                        instructions: currentExercise.instructions,
                        isHold: currentExercise.isHold,
                        tempo: tempo,
                      ),
              ),
            ),

            _buildFooterAction(
              context,
              currentExercise,
              _currentExerciseIndex,
              _exercises.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader(BuildContext context, int total, int current) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingL,
        vertical: DesignSystem.spacingM,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: IconButton(
              onPressed: () => _showExitConfirmation(context),
              icon: const Icon(Symbols.close, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
          const SizedBox(width: DesignSystem.spacingL),
          Expanded(
            child: _HealthProgressPills(total: total, current: current),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterAction(
    BuildContext context,
    engine.Exercise currentExercise,
    int currentIndex,
    int totalExercises,
  ) {
    final theme = Theme.of(context);
    final isLast =
        (_currentExerciseIndex == _exercises.length - 1) &&
        (_currentSet == currentExercise.sets);

    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          currentExercise.name.toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'EXERCISE ${currentIndex + 1} OF $totalExercises',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignSystem.spacingL),
            GestureDetector(
              onTap: () {
                if (_isResting) {
                  _endRest();
                } else {
                  _completedVolumes.add(currentExercise.baseReps);
                  _onSetComplete(
                    currentExercise,
                    engine.WorkoutEngine.getRestDuration(1).inSeconds,
                  );
                }
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: ShapeDecoration(
                  color: _isResting
                      ? Colors.transparent
                      : theme.colorScheme.primary,
                  shape: CircleBorder(
                    side: _isResting
                        ? BorderSide(color: theme.colorScheme.outlineVariant)
                        : BorderSide.none,
                  ),
                  shadows: _isResting
                      ? null
                      : [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                child: Icon(
                  _isResting
                      ? Symbols.skip_next
                      : (isLast ? Symbols.check : Symbols.arrow_forward),
                  color: _isResting
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onPrimary,
                  size: 32,
                  fill: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
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
              Text(
                'Pause Workout?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'If you quit now, your progress for today won\'t be saved. You\'re doing great, keep pushing!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXXL),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text('RESUME'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close sheet
                    Navigator.pop(context); // Exit workout
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                    foregroundColor: theme.colorScheme.error,
                  ),
                  child: const Text('QUIT WORKOUT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryScreen(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Symbols.bedtime,
                  size: 60,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXXL),
              Text(
                'RECOVERY DAY',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Growth happens during rest. Take it easy today, stay hydrated, and let your muscles rebuild.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 64),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton(
                  onPressed: () => _finishWorkout(
                    context.read<UserProgressBloc>().state.progress.currentDay,
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('COMPLETE RECOVERY'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthProgressPills extends StatelessWidget {
  final int total;
  final int current;

  const _HealthProgressPills({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: List.generate(total, (i) {
        final isCompleted = i < current;
        final isCurrent = i == current;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
            child: AnimatedContainer(
              duration: 300.ms,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isCompleted
                    ? theme.colorScheme.primary
                    : isCurrent
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ExerciseView extends StatelessWidget {
  final String name;
  final int reps;
  final int currentSet;
  final int totalSets;
  final String? description;
  final String instructions;
  final bool isHold;
  final String? tempo;

  const _ExerciseView({
    super.key,
    required this.name,
    required this.reps,
    required this.currentSet,
    required this.totalSets,
    this.description,
    required this.instructions,
    required this.isHold,
    this.tempo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'SET $currentSet OF $totalSets',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          Text(
            reps == -1 ? '∞' : '$reps',
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 140,
              fontWeight: FontWeight.w200,
              height: 1,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            isHold ? 'SECONDS' : (reps == -1 ? 'UNTIL FAILURE' : 'TARGET REPS'),
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (tempo != null) ...[
            const SizedBox(height: DesignSystem.spacingXXL),
            Text(
              'TEMPO: $tempo',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RestView extends StatelessWidget {
  final int seconds;
  final int totalSeconds;

  const _RestView({
    super.key,
    required this.seconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = seconds / totalSeconds;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'REST',
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 10,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingXXL),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                strokeCap: StrokeCap.round,
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
                  '$seconds',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 120,
                    fontWeight: FontWeight.w200,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                )
                .animate(key: ValueKey(seconds))
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: 200.ms,
                  curve: Curves.easeOutBack,
                ),
          ],
        ),
        const SizedBox(height: DesignSystem.spacingXXL),
        Text(
          'KEEP BREATHE',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class CurveTwice extends Curve {
  final Curve curve;
  const CurveTwice(this.curve);
  @override
  double transformInternal(double t) {
    if (t < 0.5) return curve.transform(t * 2) * 0.5;
    return 0.5 + curve.transform((t - 0.5) * 2) * 0.5;
  }
}
