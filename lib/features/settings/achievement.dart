import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/widgets/modern_app_bar.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<WorkoutCubit, WorkoutState, int>(
      selector: (state) => state.progress.currentDay,
      builder: (context, currentDay) {
        final achievements = _getAchievements(currentDay);
        final unlocked = achievements.where((a) => a.isUnlocked).toList();
        final locked = achievements.where((a) => !a.isUnlocked).toList();

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: const ModernAppBar(title: 'Milestones'),
          body: SafeArea(
            child: ListView(
              padding: DesignSystem.pagePadding(DesignSystem.spacingL),
              children: [
                _buildHeroSection(
                  context,
                  unlocked.length,
                  achievements.length,
                ),
                const SizedBox(height: DesignSystem.spacingXL),
                if (unlocked.isNotEmpty) ...[
                  _sectionTitle(context, 'UNLOCKED'),
                  const SizedBox(height: DesignSystem.spacingM),
                  _buildGrid(context, unlocked),
                  const SizedBox(height: DesignSystem.spacingXL),
                ],
                if (locked.isNotEmpty) ...[
                  _sectionTitle(context, 'LOCKED'),
                  const SizedBox(height: DesignSystem.spacingM),
                  _buildGrid(context, locked),
                ],
                const SizedBox(height: DesignSystem.spacingXXL),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context, int unlocked, int total) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$unlocked of $total milestones unlocked',
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingXL),
        decoration: DesignSystem.cardDecoration(context),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                Symbols.rewarded_ads,
                size: 48,
                color: theme.colorScheme.primary,
                fill: 1,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingL),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unlocked / $total',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Milestones Unlocked',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        letterSpacing: 2,
        color: theme.colorScheme.outline,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<_Achievement> achievements) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: DesignSystem.spacingM,
        crossAxisSpacing: DesignSystem.spacingM,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final a = achievements[index];
        return _BadgeCard(achievement: a);
      },
    );
  }

  List<_Achievement> _getAchievements(int currentDay) {
    return [
      _Achievement(
        title: 'Initiation',
        icon: Symbols.star,
        dayRequired: 1,
        description: 'Complete your first workout',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'Week Warrior',
        icon: Symbols.calendar_month,
        dayRequired: 7,
        description: 'Survive 7 days',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'Iron Will',
        icon: Symbols.shield,
        dayRequired: 14,
        description: '14-day streak',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'Ascension',
        icon: Symbols.trending_up,
        dayRequired: 25,
        description: 'Reach C-Class Hero',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'Half Century',
        icon: Symbols.flag,
        dayRequired: 50,
        description: 'Reach the halfway point',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'S-Class',
        icon: Symbols.military_tech,
        dayRequired: 75,
        description: 'Reach S-Class Hero rank',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'Century Club',
        icon: Symbols.trophy,
        dayRequired: 100,
        description: 'Complete 100 days',
        currentDay: currentDay,
      ),
      _Achievement(
        title: 'Saitama',
        icon: Symbols.bolt,
        dayRequired: 100,
        description: 'Become One Punch Man',
        currentDay: currentDay,
      ),
    ];
  }
}

class _Achievement {
  final String title;
  final IconData icon;
  final int dayRequired;
  final String description;
  final int currentDay;

  _Achievement({
    required this.title,
    required this.icon,
    required this.dayRequired,
    required this.description,
    required this.currentDay,
  });

  bool get isUnlocked => currentDay > dayRequired;
}

class _BadgeCard extends StatelessWidget {
  final _Achievement achievement;

  const _BadgeCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = achievement.isUnlocked;

    return Semantics(
      label:
          '${achievement.title} badge, ${unlocked ? "unlocked" : "locked"}. ${achievement.description}.',
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: unlocked
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
          borderRadius: BorderRadius.circular(DesignSystem.radiusM),
          border: Border.all(
            color: unlocked
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              achievement.icon,
              size: 28,
              color: unlocked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.4),
              fill: unlocked ? 1 : 0,
            ),
            const SizedBox(height: DesignSystem.spacingS),
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: unlocked
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.outline,
                letterSpacing: 0.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
