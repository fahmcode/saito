import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/features/home/progress_ring.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';
import 'package:saito/features/workout/workout_screen.dart';
import 'package:saito/core/data/data_sources/quote_data.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/features/faq/hero_faq_screen.dart';
import 'package:saito/features/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (context, state) {
        final progress = state.progress;
        final quote = QuoteData.getQuoteForDay(progress.currentDay);
        final canWorkout = progress.canWorkoutToday;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: DesignSystem.pagePadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: DesignSystem.spacingL),
                  HomeHeader(
                    title: 'SAITO-100',
                    rank: progress.rank,
                    onSettingsPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    onInfoPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HeroFaqScreen(),
                        ),
                      );
                    },
                  ),
                  const Spacer(flex: 2),
                  Center(
                    child: ProgressRing(
                      day: progress.currentDay,
                      doodle: Icon(
                        canWorkout ? Symbols.bolt : Symbols.lock_clock,
                        color: canWorkout
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        size: 32,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                  AnimeQuoteCard(quote: quote.text, author: quote.author),

                  const SizedBox(height: DesignSystem.spacingXL),
                  if (!canWorkout)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: DesignSystem.spacingM,
                        ),
                        child: Text(
                          'DAILY QUOTA REACHED. REST WELL, HERO.',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: canWorkout
                        ? () {
                            HapticFeedback.mediumImpact();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WorkoutScreen(),
                              ),
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(canWorkout ? 'Enter the Dojo' : 'Dojo Locked'),
                  ),
                  const SizedBox(height: DesignSystem.spacingL),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeHeader extends StatelessWidget {
  final String title;
  final String rank;
  final VoidCallback onSettingsPressed;
  final VoidCallback onInfoPressed;

  const HomeHeader({
    super.key,
    required this.title,
    required this.rank,
    required this.onSettingsPressed,
    required this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXS),
            Text(
              'Rank: ${rank.toUpperCase()}',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w300,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onInfoPressed,
              icon: Icon(
                Symbols.help,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
            IconButton(
              onPressed: onSettingsPressed,
              icon: Icon(
                Symbols.tune,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AnimeQuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const AnimeQuoteCard({super.key, required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: DesignSystem.cardDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Symbols.format_quote,
              color: theme.colorScheme.primary,
              size: 32,
            ).animate().fadeIn(duration: 400.ms).rotate(begin: -0.05, end: 0),
            const SizedBox(height: DesignSystem.spacingS),
            Text(
              quote,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '— $author',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
