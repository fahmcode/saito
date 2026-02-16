import 'package:flutter/material.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/widgets/modern_app_bar.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const int totalUnlocked = 4;
    const int totalBadges = 12;

    return Scaffold(
      appBar: const ModernAppBar(title: 'Milestones'),
      backgroundColor: theme.colorScheme.surface,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildAchievementHero(context, totalUnlocked, totalBadges),
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'UNLOCKED', totalUnlocked),
                const SizedBox(height: DesignSystem.spacingM),
                _buildBadgeGrid(context, true),
                const SizedBox(height: DesignSystem.spacingXL),
                _buildSectionHeader(
                  context,
                  'LOCKED',
                  totalBadges - totalUnlocked,
                ),
                const SizedBox(height: DesignSystem.spacingM),
                _buildBadgeGrid(context, false),
                const SizedBox(height: DesignSystem.spacingXXL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementHero(BuildContext context, int unlocked, int total) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        DesignSystem.spacingL,
        DesignSystem.spacingXL,
        DesignSystem.spacingL,
        DesignSystem.spacingXXL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hall of Fame',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$unlocked OF $total MILESTONES'.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Every drop of sweat is a brick in your fortress. Collect milestones to showcase your path to mastery.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeGrid(BuildContext context, bool unlocked) {
    final badges = unlocked
        ? [
            ('Initiation', Symbols.bolt, 'Start the 100-day journey'),
            (
              'First Week',
              Symbols.calendar_today,
              'Complete 7 consecutive days',
            ),
            ('Armor Up', Symbols.shield, 'Complete 5 Armor sessions'),
            (
              'Iron Will',
              Symbols.fitness_center,
              'Complete a workout with maximum intensity',
            ),
          ]
        : [
            ('Halfway there', Symbols.star, 'Reach day 50'),
            ('Century Club', Symbols.military_tech, 'Complete all 100 days'),
            (
              'King of Shred',
              Symbols.local_fire_department,
              'Unlock Shred Phase 3',
            ),
            ('Unstoppable', Symbols.trophy, 'Complete 30 days without rest'),
            ('Early Bird', Symbols.wb_sunny, 'Workout before 7 AM'),
            ('Night Owl', Symbols.dark_mode, 'Workout after 10 PM'),
            ('Mastery', Symbols.diamond, 'Perform 500 total sets'),
            ('Resilience', Symbols.healing, 'Complete recovery phase twice'),
          ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DesignSystem.spacingM,
        mainAxisSpacing: DesignSystem.spacingM,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _buildBadgeTile(context, badge.$1, badge.$2, badge.$3, unlocked);
      },
    );
  }

  Widget _buildBadgeTile(
    BuildContext context,
    String title,
    IconData icon,
    String desc,
    bool unlocked,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: unlocked
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unlocked
              ? theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 0.5,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: unlocked
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.outline.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: unlocked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              fill: unlocked ? 1 : 0,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
              color: unlocked
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
