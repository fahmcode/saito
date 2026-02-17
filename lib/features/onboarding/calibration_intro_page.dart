import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CalibrationIntroPage extends StatelessWidget {
  final VoidCallback onContinue;
  const CalibrationIntroPage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),

          Text(
                'Set your\nbaseline',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: DesignSystem.spacingM),

          Text(
                'We need your current max reps for three exercises. '
                'This lets us build a program that grows with you.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: DesignSystem.spacingXL),

          ..._exercisePreviews(theme),

          const Spacer(flex: 3),

          FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Continue'),
          ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
        ],
      ),
    );
  }

  List<Widget> _exercisePreviews(ThemeData theme) {
    const exercises = [
      ('Armor', 'Diamond Push-ups', Symbols.shield_rounded),
      ('Foundation', 'Prisoner Squats', Symbols.fitness_center_rounded),
      ('Shred', 'Pull-ups', Symbols.cyclone_rounded),
    ];

    return exercises.asMap().entries.map((e) {
      final (name, exercise, icon) = e.value;
      return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      exercise,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 400.ms, delay: (300 + e.key * 80).ms)
          .slideX(begin: 0.05, curve: Curves.easeOut);
    }).toList();
  }
}
