import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/core/logic/cubit/preferences_cubit.dart';
import 'package:saito/features/workout/workout_complete_screen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'scale_button.dart';

class RecoveryView extends StatelessWidget {
  final int day;

  const RecoveryView({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ScaleButton(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.05,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Symbols.close, size: 20),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Symbols.bedtime,
                  size: 48,
                  color: theme.colorScheme.primary,
                  fill: 1,
                ),
              ).animate().scale(
                begin: const Offset(0.95, 0.95),
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              ),
              const SizedBox(height: 48),
              Text(
                'Recovery day',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w200,
                  letterSpacing: -1,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.02, end: 0),
              const SizedBox(height: 16),
              Text(
                'Take it easy. Light stretching and mobility work will help your muscles rebuild stronger.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.6,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const Spacer(flex: 3),
              ScaleButton(
                    onTap: () => _confirmRecovery(context),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          DesignSystem.radiusMax,
                        ),
                        boxShadow: DesignSystem.mediumShadow(context),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Complete recovery',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideY(begin: 0.02, end: 0),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRecovery(BuildContext context) {
    _triggerHaptic(context, HapticFeedback.mediumImpact);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Complete recovery?'),
        content: const Text('Have you rested and recovered today?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Not yet'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _finishRecovery(context);
            },
            child: const Text('Yes, finish'),
          ),
        ],
      ),
    );
  }

  void _finishRecovery(BuildContext context) {
    _triggerHaptic(context, HapticFeedback.heavyImpact);
    final workoutCubit = context.read<WorkoutCubit>();
    final progress = workoutCubit.state.progress;

    workoutCubit.completeDay(day: day, volume: []);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            WorkoutCompleteScreen(completedDay: day, progress: progress),
      ),
    );
  }

  void _triggerHaptic(BuildContext context, VoidCallback feedback) {
    if (context.read<PreferencesCubit>().state.preferences.hapticsEnabled) {
      feedback();
    }
  }
}
