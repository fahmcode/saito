import 'package:flutter/material.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/cubit/workout_session_cubit.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'scale_button.dart';

class WorkoutFooter extends StatelessWidget {
  final WorkoutSessionState session;
  final VoidCallback onComplete;
  final VoidCallback onSkipRest;

  const WorkoutFooter({
    super.key,
    required this.session,
    required this.onComplete,
    required this.onSkipRest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isResting = session.phase == SessionPhase.resting;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isResting ? 'Rest' : session.currentExercise.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isResting
                      ? 'Up next: ${session.nextExercise?.name ?? "Finish"}'
                      : 'Set ${session.currentSet} of ${session.currentExercise.sets}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignSystem.spacingM),
          ScaleButton(
            onTap:
                onComplete, // onComplete handles both skipping and completing
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: DesignSystem.mediumShadow(context),
              ),
              child: Icon(
                isResting
                    ? Symbols.fast_forward
                    : (session.isLast ? Symbols.check : Symbols.arrow_forward),
                color: theme.colorScheme.onPrimary,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
