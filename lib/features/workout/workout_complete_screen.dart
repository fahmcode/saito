import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/data/models/workout_progress.dart';
import 'package:saito/core/data/data_sources/quote_data.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/features/workout/scale_button.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  final int completedDay;
  final WorkoutProgress progress;

  const WorkoutCompleteScreen({
    super.key,
    required this.completedDay,
    required this.progress,
  });

  @override
  State<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {
  @override
  void initState() {
    super.initState();
    _triggerHaptic();
  }

  void _triggerHaptic() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) HapticFeedback.mediumImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quote = QuoteData.getQuoteForDay(widget.completedDay);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Trophy/Celebration Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Symbols.trophy,
                      size: 56,
                      color: theme.colorScheme.primary,
                      fill: 1,
                    ),
                  ),
                ).animate().scale(
                  begin: const Offset(0.9, 0.9),
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                ),
                const SizedBox(height: DesignSystem.spacingXXL),
                Text(
                      'Day ${widget.completedDay}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w200,
                        fontSize: 64,
                        letterSpacing: -2,
                        color: theme.colorScheme.onSurface,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.02, end: 0),
                Text(
                  'Conquered',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const Spacer(flex: 3),
                _buildStats(context),
                const Spacer(),
                _buildQuote(context, quote),
                const Spacer(flex: 2),
                ScaleButton(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
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
                          'Continue journey',
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
                const SizedBox(height: DesignSystem.spacingM),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Rank',
            value: widget.progress.rank,
            icon: Symbols.military_tech,
          ),
          _StatItem(
            label: 'Progress',
            value: '${widget.completedDay}/100',
            icon: Symbols.calendar_today,
          ),
          _StatItem(
            label: 'Streak',
            value: '${widget.progress.streak}',
            icon: Symbols.local_fire_department,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildQuote(BuildContext context, Quote quote) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            '"${quote.text}"',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            '— ${quote.author}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: theme.colorScheme.primary.withValues(alpha: 0.8),
        ),
        const SizedBox(height: DesignSystem.spacingM),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
