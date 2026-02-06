import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/core/config/design_system.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  final int day;

  const WorkoutCompleteScreen({super.key, required this.day});

  @override
  State<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {
  @override
  void initState() {
    super.initState();
    _playSuccessEffects();
  }

  void _playSuccessEffects() async {
    // Initial impact
    await Future.delayed(200.ms);
    HapticFeedback.heavyImpact();

    // Series of lighter impacts for "confetti" feel
    await Future.delayed(400.ms);
    HapticFeedback.lightImpact();
    await Future.delayed(100.ms);
    HapticFeedback.lightImpact();
    await Future.delayed(100.ms);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: DesignSystem.pagePadding(DesignSystem.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon Circle
              Container(
                    padding: const EdgeInsets.all(DesignSystem.spacingXL),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Symbols.trophy,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .then()
                  .shimmer(duration: 1200.ms, color: Colors.white),

              const SizedBox(height: DesignSystem.spacingXL),

              // Title
              Text(
                    'DAY ${widget.day} COMPLETE',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: DesignSystem.spacingM),

              // Subtitle
              Text(
                'YOU ARE ONE STEP CLOSER TO ABSOLUTE STRENGTH.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 500.ms),

              const Spacer(),

              // Stat Card
              Container(
                    padding: const EdgeInsets.all(DesignSystem.spacingL),
                    decoration: DesignSystem.cardDecoration(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          label: 'STATUS',
                          value: 'ACTIVE',
                          icon: Symbols.check_circle,
                          delay: 700.ms,
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        _StatItem(
                          label: 'RECOVERY',
                          value: 'EARNED',
                          icon: Symbols.spa,
                          delay: 900.ms,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: FilledButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text('CONTINUE'),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 1000.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Duration delay;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28)
            .animate(delay: delay)
            .scale(duration: 400.ms, curve: Curves.elasticOut),
        const SizedBox(height: DesignSystem.spacingXS),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
