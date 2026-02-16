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
    await Future.delayed(200.ms);
    HapticFeedback.heavyImpact();
    await Future.delayed(400.ms);
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingL,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Celebration Hero
                    Container(
                          width: 140,
                          height: 140,
                          decoration: ShapeDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            shape: const StarBorder(
                              points: 8,
                              innerRadiusRatio: 0.85,
                              pointRounding: 0.4,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Symbols.trophy,
                                size: 40,
                                color: theme.colorScheme.onPrimary,
                                fill: 1,
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut)
                        .shimmer(delay: 800.ms, duration: 1200.ms),

                    const SizedBox(height: DesignSystem.spacingXXL),

                    Text(
                          'DAY ${widget.day} COMPLETE',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            height: 1,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 12),

                    Text(
                      'YOUR FORTRESS IS GROWING STRONGER.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: DesignSystem.spacingHero),

                    // Grouped Stats section
                    Container(
                          padding: const EdgeInsets.all(DesignSystem.spacingXL),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildStat(
                                context,
                                'STATUS',
                                'ELITE',
                                Symbols.check_circle,
                              ),
                              _buildDivider(theme),
                              _buildStat(
                                context,
                                'REWARD',
                                'ASHES',
                                Symbols.local_fire_department,
                              ),
                              _buildDivider(theme),
                              _buildStat(
                                context,
                                'STREAK',
                                'EARNED',
                                Symbols.bolt,
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 800.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),

            // Fixed Footer Action
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingL),
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: FilledButton.styleFrom(shape: const StadiumBorder()),
                  child: const Text(
                    'CONTINUE JOURNEY',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
