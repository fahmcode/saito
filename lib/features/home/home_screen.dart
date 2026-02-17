import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/widgets/profile_avatar.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/features/home/day_details.dart';
import 'package:saito/widgets/day_progress.dart';
import 'package:saito/features/settings/achievement.dart';
import 'package:saito/features/settings/settings_screen.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Only rebuild the basic scaffold structure when theme/identity changes
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(header: true, child: const Text('SAITO-100')),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementScreen()),
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              foregroundColor: theme.colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Milestones',
            icon: const Icon(Symbols.rewarded_ads, fill: 1),
          ),
          ProfileAvatarButton(
            imageUrl: null,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          const SizedBox(width: DesignSystem.spacingM),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DesignSystem.spacingL),
              Expanded(
                // P3: Only rebuild the 100-item grid when currentDay or startDate changes
                child:
                    BlocSelector<WorkoutCubit, WorkoutState, (int, DateTime?)>(
                      selector: (state) =>
                          (state.progress.currentDay, state.progress.startDate),
                      builder: (context, data) {
                        final currentDay = data.$1;
                        final startDate = data.$2;

                        final days = List.generate(100, (index) {
                          final dayNum = index + 1;
                          final date = _calculateDate(
                            startDate,
                            currentDay,
                            index,
                          );

                          return DayProgress(
                            date: date,
                            status: _getStatus(dayNum, currentDay),
                            dayNumber: dayNum,
                          );
                        });

                        return ProgressGrid(
                          days: days,
                          onDayTap: (day) => _handleDayTap(context, day),
                        );
                      },
                    ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
            ],
          ),
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

  void _handleDayTap(BuildContext context, DayProgress day) {
    if (day.dayNumber == null) return;
    HapticFeedback.lightImpact();

    // We get the progress here once when needed instead of passing it around
    final progress = context.read<WorkoutCubit>().state.progress;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            DayDetailsScreen(dayNumber: day.dayNumber!, progress: progress),
      ),
    );
  }
}
