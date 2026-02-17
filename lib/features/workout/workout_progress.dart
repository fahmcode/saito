import 'package:flutter/material.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/engine/workout_engine.dart' as engine;

class WorkoutProgress extends StatelessWidget {
  final List<engine.Exercise> exercises;
  final int currentIndex;
  final int currentSet;

  const WorkoutProgress({
    super.key,
    required this.exercises,
    required this.currentIndex,
    required this.currentSet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingL,
        vertical: DesignSystem.spacingS,
      ),
      child: Row(
        children: List.generate(exercises.length, (index) {
          final exercise = exercises[index];
          final isCompleted = index < currentIndex;
          final isCurrent = index == currentIndex;
          final setProgress = isCurrent ? currentSet / exercise.sets : 0.0;

          return Expanded(
            child: Semantics(
              label:
                  '${exercise.name}, exercise ${index + 1} of ${exercises.length}${isCompleted
                      ? ", completed"
                      : isCurrent
                      ? ", in progress"
                      : ""}',
              child: Container(
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: isCompleted
                      ? 1.0
                      : (isCurrent ? setProgress : 0.0),
                  child: AnimatedContainer(
                    duration: DesignSystem.durationFast,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
