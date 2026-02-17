import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class BaselinePickerPage extends StatelessWidget {
  final ValueNotifier<int> armor;
  final ValueNotifier<int> foundation;
  final ValueNotifier<int> shred;
  final VoidCallback onContinue;

  const BaselinePickerPage({
    super.key,
    required this.armor,
    required this.foundation,
    required this.shred,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: DesignSystem.spacingL),
          Text(
                'Your max reps',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),
          const SizedBox(height: 4),
          Text(
                'Scroll to select your current maximum for each exercise.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: DesignSystem.spacingXL),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _WheelColumn(
                    label: 'Armor',
                    subtitle: 'Push-ups',
                    icon: Symbols.shield_rounded,
                    notifier: armor,
                    initialValue: 20,
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _WheelColumn(
                    label: 'Foundation',
                    subtitle: 'Squats',
                    icon: Symbols.fitness_center_rounded,
                    notifier: foundation,
                    initialValue: 20,
                  ).animate().fadeIn(duration: 400.ms, delay: 380.ms),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _WheelColumn(
                    label: 'Shred',
                    subtitle: 'Pull-ups',
                    icon: Symbols.cyclone_rounded,
                    notifier: shred,
                    initialValue: 10,
                  ).animate().fadeIn(duration: 400.ms, delay: 460.ms),
                ),
              ],
            ),
          ),

          const SizedBox(height: DesignSystem.spacingM),

          FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Confirm Baseline'),
          ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
        ],
      ),
    );
  }
}

// ── Scroll-wheel column ────────────────────────────────────

class _WheelColumn extends StatefulWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final ValueNotifier<int> notifier;
  final int initialValue;

  const _WheelColumn({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.notifier,
    required this.initialValue,
  });

  @override
  State<_WheelColumn> createState() => _WheelColumnState();
}

class _WheelColumnState extends State<_WheelColumn> {
  late final FixedExtentScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = FixedExtentScrollController(initialItem: widget.initialValue);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Icon(widget.icon, size: 22, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        Text(
          widget.subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: _scrollCtrl,
                itemExtent: 44,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 1.6,
                perspective: 0.003,
                onSelectedItemChanged: (i) {
                  HapticFeedback.selectionClick();
                  widget.notifier.value = i;
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 101,
                  builder: (context, index) {
                    return ValueListenableBuilder<int>(
                      valueListenable: widget.notifier,
                      builder: (context, selected, _) {
                        final isSelected = index == selected;
                        return Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: isSelected ? 22 : 17,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
