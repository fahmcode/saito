import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/data/sources/sync_service.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/features/home/day_details.dart';
import 'package:saito/features/settings/settings_screen.dart';
import 'package:saito/widgets/day_progress.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = context.read<DriveSyncService?>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, workoutState) {
            final progress = workoutState.progress;
            final currentDay = progress.currentDay;
            final startDate = progress.startDate;

            final days = List.generate(100, (index) {
              final dayNum = index + 1;
              final date = _calculateDate(startDate, currentDay, index);
              return DayProgress(
                date: date,
                status: _getStatus(dayNum, currentDay),
                dayNumber: dayNum,
              );
            });

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      DesignSystem.appHorizontalPadding,
                      DesignSystem.spacingS,
                      DesignSystem.appHorizontalPadding,
                      DesignSystem.spacingS,
                    ),
                    child: _Header(
                      onSettings: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                      onSync: sync != null
                          ? () => sync.sync('local').catchError((_) {})
                          : null,
                    ),
                  ),
                ),

                // ── Stats Row ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.appHorizontalPadding,
                      vertical: DesignSystem.spacingS,
                    ),
                    child: _StatsRow(
                      streak: progress.streak,
                      currentDay: currentDay,
                      rank: progress.rank,
                    ),
                  ),
                ),

                // ── Journey Grid ────────────────────────────
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      DesignSystem.appHorizontalPadding,
                      DesignSystem.spacingS,
                      DesignSystem.appHorizontalPadding,
                      DesignSystem.spacingXL,
                    ),
                    child: ProgressGrid(
                      days: days,
                      onDayTap: (day) {
                        if (day.dayNumber != null) {
                          _handleDayTap(context, day.dayNumber!);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  DateTime _calculateDate(DateTime? startDateField, int currentDay, int index) {
    final now = DateTime.now();
    final startDate =
        startDateField ?? now.subtract(Duration(days: currentDay - 1));
    return startDate.add(Duration(days: index));
  }

  DayStatus _getStatus(int dayNum, int currentDay) {
    if (dayNum < currentDay) return DayStatus.active;
    if (dayNum == currentDay) return DayStatus.today;
    return DayStatus.inactive;
  }

  void _handleDayTap(BuildContext context, int dayNumber) {
    HapticFeedback.lightImpact();
    final progress = context.read<WorkoutCubit>().state.progress;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            DayDetailsScreen(dayNumber: dayNumber, progress: progress),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  HEADER
// ═══════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback? onSync;
  const _Header({required this.onSettings, required this.onSync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            'Baki',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        if (onSync != null)
          IconButton(
            onPressed: onSync,
            icon: const Icon(Symbols.cloud_sync, weight: 600),
            tooltip: 'Sync now',
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        IconButton(
          onPressed: onSettings,
          icon: const Icon(Symbols.settings, weight: 500),
          tooltip: 'Settings',
          style: IconButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int streak;
  final int currentDay;
  final String rank;
  const _StatsRow({
    required this.streak,
    required this.currentDay,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatPill(
            icon: Symbols.local_fire_department,
            label: 'Streak',
            value: '$streak',
          ),
        ),
        const SizedBox(width: DesignSystem.spacingS),
        Expanded(
          child: _StatPill(
            icon: Symbols.trending_up,
            label: 'Progress',
            value: '$currentDay / 100',
          ),
        ),
        const SizedBox(width: DesignSystem.spacingS),
        Expanded(
          child: _StatPill(
            icon: Symbols.military_tech,
            label: 'Rank',
            value: rank,
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: DesignSystem.spacingM,
        horizontal: DesignSystem.spacingS,
      ),
      decoration: DesignSystem.surfaceDecoration(context),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
            fill: 1,
            weight: 600,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
