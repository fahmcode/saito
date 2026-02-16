import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saito/widgets/modern_app_bar.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/engine/workout_engine.dart';
import 'package:saito/core/data/models/user_progress.dart';
import 'package:saito/features/workout/workout_screen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DayDetailsScreen extends StatelessWidget {
  final int dayNumber;
  final UserProgress progress;

  const DayDetailsScreen({
    super.key,
    required this.dayNumber,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workoutType = WorkoutEngine.getWorkoutType(dayNumber);
    final phase = WorkoutEngine.getPhase(dayNumber);
    final exercises = WorkoutEngine.getExercisesForDay(
      dayNumber,
      progress.baselineReps,
    );
    final isCompleted = dayNumber < progress.currentDay;
    final isToday = dayNumber == progress.currentDay;
    final isRecovery = workoutType == WorkoutType.recovery;
    final volume = progress.dailyVolume[dayNumber];
    final canStartWorkout = isToday && !isCompleted;

    return Scaffold(
      appBar: ModernAppBar(
        title: 'Day $dayNumber',
        actions: [
          if (isCompleted)
            Padding(
              padding: const EdgeInsets.only(right: DesignSystem.spacingM),
              child: Icon(
                Symbols.check_circle,
                color: Colors.green.shade600,
                size: 20,
                fill: 1,
              ),
            ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeroHeader(
            context,
            workoutType,
            phase,
            canStartWorkout,
            isRecovery,
          ),

          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionActionHeader(
                  context,
                  isRecovery ? 'RECOVERY PLAN' : 'EXERCISES',
                  exercises.length,
                  canStartWorkout,
                ),
                const SizedBox(height: DesignSystem.spacingM),
                if (isRecovery)
                  _buildAppleRecovery(theme)
                else
                  _buildAppleExerciseList(
                    context,
                    exercises,
                    volume,
                    isCompleted,
                  ),
                const SizedBox(height: DesignSystem.spacingXXL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(
    BuildContext context,
    WorkoutType type,
    WorkoutPhase phase,
    bool canStart,
    bool isRecovery,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignSystem.spacingL,
        DesignSystem.spacingXL,
        DesignSystem.spacingL,
        DesignSystem.spacingXXL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phase.name.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getWorkoutDescription(type),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (canStart) _buildHeroAction(context, isRecovery),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAction(BuildContext context, bool isRecovery) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: DesignSystem.spacingL),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WorkoutScreen()),
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: ShapeDecoration(
            color: theme.colorScheme.primary,
            shape: const StadiumBorder(),
          ),
          child: Icon(
            Symbols.play_arrow,
            color: theme.colorScheme.onPrimary,
            size: 36,
            fill: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionActionHeader(
    BuildContext context,
    String title,
    int itemCount,
    bool canStart,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$itemCount exercises',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppleExerciseList(
    BuildContext context,
    List<Exercise> exercises,
    List<int>? volume,
    bool isCompleted,
  ) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 72,
          endIndent: 16,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final setsPerformed = volume != null && index < volume.length
              ? volume[index]
              : null;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: DesignSystem.spacingL,
              horizontal: DesignSystem.spacingL,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Symbols.fitness_center,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: DesignSystem.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${exercise.sets} sets × ${exercise.baseReps}${exercise.isHold ? "s hold" : " reps"}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  _buildAppleVolumeBadge(
                    context,
                    setsPerformed ?? exercise.baseReps,
                  ),
                const SizedBox(width: 8),
                Icon(
                  Symbols.more_vert,
                  size: 20,
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppleRecovery(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingXXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Symbols.bedtime,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: DesignSystem.spacingL),
          Text(
            'Active Recovery',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Rest and allow your muscles to rebuild. Light stretching encouraged for optimal flow.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWorkoutDescription(WorkoutType type) {
    switch (type) {
      case WorkoutType.armor:
        return 'Build defensive strength and resilience through high-repetition bodyweight sets.';
      case WorkoutType.foundation:
        return 'Core stabilization and fundamental power. The bedrock of your physical capacity.';
      case WorkoutType.shred:
        return 'High intensity lean muscle focus. Pushing your limits to redefine your physique.';
      case WorkoutType.recovery:
        return 'Active rest for muscle optimization. Essential period for growth and repair.';
    }
  }

  Widget _buildAppleVolumeBadge(BuildContext context, int reps) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$reps',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
