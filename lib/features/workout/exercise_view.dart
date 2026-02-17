import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/engine/workout_engine.dart' as engine;

class ExerciseView extends StatelessWidget {
  final engine.Exercise exercise;
  final int setNumber;

  const ExerciseView({
    super.key,
    required this.exercise,
    required this.setNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Text(
                '${exercise.baseReps}',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 120,
                  fontWeight: FontWeight.w200,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -5,
                ),
              )
              .animate(key: ValueKey('count_${exercise.name}_$setNumber'))
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
          Text(
            exercise.isHold ? 'seconds' : 'reps',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const Spacer(flex: 3),
          Text(
            exercise.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            exercise.instructions,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
