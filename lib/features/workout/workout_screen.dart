import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/features/faq/hero_faq_screen.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
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

  void _playSound(String effect) async {
    final progress = context.read<UserProgressBloc>().state.progress;
    try {
      if (effect == 'success') {
        if (progress.hapticsEnabled) HapticFeedback.heavyImpact();
      } else if (effect == 'tick') {
        if (progress.hapticsEnabled) HapticFeedback.selectionClick();
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
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<UserProgressBloc>().state.progress;
    final workoutType = engine.WorkoutEngine.getWorkoutType(
      progress.currentDay,
    );
    final phase = engine.WorkoutEngine.getPhase(progress.currentDay);

    if (workoutType == engine.WorkoutType.recovery) {
      return _buildRecoveryScreen(context);
    }

    if (_exercises.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No exercises found for today.')),
      );
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    final restDuration = engine.WorkoutEngine.getRestDuration(
      progress.currentDay,
    );
    final tempo = engine.WorkoutEngine.getTempo(progress.currentDay);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: DesignSystem.pagePadding(),
          child: Column(
            children: [
              const SizedBox(height: DesignSystem.spacingM),
              _WorkoutHeader(
                phaseName: phase.name.toUpperCase(),
                totalExercises: _exercises.length,
                currentExerciseIndex: _currentExerciseIndex,
                onClose: () => _showExitConfirmation(context),
                onInfo: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HeroFaqScreen()),
                  );
                },
              ),
              const Spacer(),
              Expanded(
                flex: 8,
                child: AnimatedSwitcher(
                  duration: DesignSystem.durationMedium,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _isResting
                      ? _RestView(
                          key: const ValueKey('rest_view'),
                          seconds: _secondsRemaining,
                          totalSeconds: restDuration.inSeconds,
                        )
                      : _ExerciseView(
                          key: ValueKey(
                            'exercise_view_${_currentExerciseIndex}_$_currentSet',
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
              const Spacer(),
              _ActionButton(
                isResting: _isResting,
                isLast:
                    (_currentExerciseIndex == _exercises.length - 1) &&
                    (_currentSet == currentExercise.sets),
                onPressed: () {
                  if (_isResting) {
                    _endRest();
                  } else {
                    _completedVolumes.add(currentExercise.baseReps);
                    _onSetComplete(currentExercise, restDuration.inSeconds);
                  }
                },
              ),
              const SizedBox(height: DesignSystem.spacingL),
            ],
          ),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure?',

                style: theme.textTheme.titleLarge?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                'If you quit, you will not be able to complete this workout.',
                textAlign: TextAlign.start,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continue Workout'),
                ),
              ),

              const SizedBox(height: DesignSystem.spacingS),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context); // Close sheet
                    Navigator.pop(context); // Close screen
                  },
                  child: const Text('Quit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildRecoveryScreen(BuildContext context) {
    final theme = Theme.of(context);
    final progress = context.read<UserProgressBloc>().state.progress;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: DesignSystem.pagePadding(DesignSystem.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.spa_rounded,
                size: 80,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              Text('RECOVERY DAY', style: theme.textTheme.displayMedium),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                'REST IS THE BRIDGE BETWEEN TRAINING AND TRANSFORMATION.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingHero),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _finishWorkout(progress.currentDay),
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

class _WorkoutHeader extends StatelessWidget {
  final String phaseName;
  final int totalExercises;
  final int currentExerciseIndex;
  final VoidCallback onClose;
  final VoidCallback onInfo;

  const _WorkoutHeader({
    required this.phaseName,
    required this.totalExercises,
    required this.currentExerciseIndex,
    required this.onClose,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filledTonal(
              onPressed: onClose,
              icon: const Icon(Symbols.close),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
              ),
            ),

            Expanded(
              child: StepPillProgress(
                totalSteps: totalExercises,
                currentStep: currentExerciseIndex,
              ),
            ),

            IconButton.filledTonal(
              onPressed: onInfo,
              icon: const Icon(Symbols.info),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StepPillProgress extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 0-based index

  const StepPillProgress({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: List.generate(totalSteps, (i) {
        final isCompleted = i < currentStep;
        final isCurrent = i == currentStep;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isCompleted
                    ? theme.colorScheme.primary
                    : isCurrent
                    ? Colors.transparent
                    : theme.colorScheme.surfaceContainerHighest,
                border: isCurrent
                    ? Border.all(color: theme.colorScheme.primary, width: 1.4)
                    : null,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SET $currentSet OF $totalSets',
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.5,
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 48), // Spacer to balance the icon
            Expanded(
              child: Text(
                name.toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => _showInstructions(context),
              icon: const Icon(Symbols.help),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
              ),
            ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: DesignSystem.spacingS),
          Text(
            description!.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.outline,
              letterSpacing: 1.1,
            ),
          ),
        ],
        const SizedBox(height: DesignSystem.spacingXL),
        Text(
          reps == -1 ? '∞' : '$reps',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 120,
            fontWeight: FontWeight.w200,
            height: 1,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Text(
          isHold ? 'SECONDS' : (reps == -1 ? 'UNTIL FAILURE' : 'TARGET REPS'),
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 2,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (tempo != null) ...[
          const SizedBox(height: DesignSystem.spacingXXL),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tempo!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showInstructions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Symbols.info, color: theme.colorScheme.onSurface),
                  const SizedBox(width: 12),
                  Text(
                    'Instructions',
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                instructions,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('GOT IT'),
                ),
              ),
            ],
          ),
        ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'BREATHE',
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 8,
            color: theme.colorScheme.outline,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingXL),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: seconds / totalSeconds,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
                  '$seconds',
                  key: ValueKey(seconds),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 100,
                    fontWeight: FontWeight.w300,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: 500.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1.05, 1.05),
                  end: const Offset(1.0, 1.0),
                  duration: 500.ms,
                ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isResting;
  final bool isLast;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.isResting,
    required this.isLast,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isResting
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: const Text('SKIP REST'),
            )
          : FilledButton(
              onPressed: onPressed,
              child: Text(isLast ? 'FINISH WORKOUT' : 'COMPLETE SET'),
            ),
    );
  }
}
