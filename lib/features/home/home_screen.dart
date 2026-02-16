import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/widgets/profile_avatar.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/features/home/day_details.dart';
import 'package:saito/widgets/day_progress.dart';
import 'package:saito/features/settings/achievement.dart';
import 'package:saito/core/data/data_sources/quote_data.dart';
import 'package:saito/features/settings/settings_screen.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (context, state) {
        final progress = state.progress;
        QuoteData.getQuoteForDay(progress.currentDay);

        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('SAITO-100'),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AchievementScreen()),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                ),
                icon: const Icon(Symbols.rewarded_ads, fill: 1),
              ),
              ProfileAvatarButton(
                imageUrl: null,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
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
                    child: ProgressGrid(
                      days: List.generate(100, (index) {
                        final dayNum = index + 1;
                        final date = _calculateDate(progress, index);

                        return DayProgress(
                          date: date,
                          status: _getStatus(dayNum, progress.currentDay),
                          dayNumber: dayNum,
                        );
                      }),
                      onDayTap: (day) => _handleDayTap(context, day, progress),
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacingXL),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DateTime _calculateDate(dynamic progress, int index) {
    final now = DateTime.now();
    final startDate =
        progress.startDate ??
        now.subtract(Duration(days: progress.currentDay - 1));
    return startDate.add(Duration(days: index));
  }

  DayStatus _getStatus(int dayNum, int currentDay) {
    if (dayNum < currentDay) return DayStatus.active;
    if (dayNum == currentDay) return DayStatus.today;
    return DayStatus.inactive;
  }

  void _handleDayTap(BuildContext context, dynamic day, dynamic progress) {
    if (day.dayNumber == null) return;
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            DayDetailsScreen(dayNumber: day.dayNumber!, progress: progress),
      ),
    );
  }
}
