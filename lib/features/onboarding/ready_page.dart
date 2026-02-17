import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ReadyPage extends StatelessWidget {
  final ValueNotifier<int> armor;
  final ValueNotifier<int> foundation;
  final ValueNotifier<int> shred;
  final VoidCallback onStart;

  const ReadyPage({
    super.key,
    required this.armor,
    required this.foundation,
    required this.shred,
    required this.onStart,
  });

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
                'You\'re ready.',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: 8),

          Text(
                'Your program is calibrated.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: DesignSystem.spacingXXL),

          // Summary rows
          ValueListenableBuilder<int>(
            valueListenable: armor,
            builder: (_, a, __) =>
                _SummaryRow(
                      icon: Symbols.shield_rounded,
                      label: 'Armor',
                      value: a,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideX(begin: 0.05),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<int>(
            valueListenable: foundation,
            builder: (_, f, __) =>
                _SummaryRow(
                      icon: Symbols.fitness_center_rounded,
                      label: 'Foundation',
                      value: f,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 380.ms)
                    .slideX(begin: 0.05),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<int>(
            valueListenable: shred,
            builder: (_, s, __) =>
                _SummaryRow(
                      icon: Symbols.cyclone_rounded,
                      label: 'Shred',
                      value: s,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 460.ms)
                    .slideX(begin: 0.05),
          ),

          const SizedBox(height: DesignSystem.spacingXL),

          // Rank badge
          Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(DesignSystem.radiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Symbols.military_tech_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting rank',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          'Human',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 550.ms)
              .scale(begin: const Offset(0.95, 0.95)),

          const Spacer(flex: 3),

          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Start Day 1'),
          ).animate().fadeIn(duration: 500.ms, delay: 650.ms),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 14),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '$value reps',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
