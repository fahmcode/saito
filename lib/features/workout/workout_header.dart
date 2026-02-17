import 'package:flutter/material.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/engine/workout_engine.dart' as engine;
import 'package:material_symbols_icons/material_symbols_icons.dart';

class WorkoutHeader extends StatelessWidget {
  final engine.WorkoutType workoutType;
  final engine.WorkoutPhase phase;
  final int day;
  final VoidCallback onClose;

  const WorkoutHeader({
    super.key,
    required this.workoutType,
    required this.phase,
    required this.day,
    required this.onClose,
  });

  String _getFormattedLabel() {
    switch (workoutType) {
      case engine.WorkoutType.armor:
        return 'Armor (Chest & Shoulders)';
      case engine.WorkoutType.foundation:
        return 'Foundation (Legs & Glutes)';
      case engine.WorkoutType.shred:
        return 'Shred (Back & Core)';
      case engine.WorkoutType.recovery:
        return 'Recovery';
    }
  }

  String _getFormattedPhase() {
    final name = phase.name.toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignSystem.spacingL,
        DesignSystem.spacingL,
        DesignSystem.spacingM,
        DesignSystem.spacingS,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedLabel(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '${_getFormattedPhase()} • Day $day',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Symbols.close, size: 20),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
