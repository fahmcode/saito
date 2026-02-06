import 'package:flutter/material.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/engine/workout_engine.dart';

class HeroFaqScreen extends StatelessWidget {
  const HeroFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Information'),
            centerTitle: false,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surface,
          ),
          SliverPadding(
            padding: DesignSystem.pagePadding(DesignSystem.spacingM),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _ProtocolSectionHeader(
                  title: 'ARMOR (Chest & Shoulders)',
                ),
                const SizedBox(height: 16),
                ...WorkoutEngine.getExercisesForDay(1, {}).map(
                  (e) => ProtocolExpansionTile(
                    exercise: e.name,
                    target: e.description ?? 'Chest & Shoulders',
                    instructions: e.instructions,
                  ),
                ),

                const SizedBox(height: 32),
                const _ProtocolSectionHeader(
                  title: 'FOUNDATION (Legs & Glutes)',
                ),
                const SizedBox(height: 16),
                ...WorkoutEngine.getExercisesForDay(2, {}).map(
                  (e) => ProtocolExpansionTile(
                    exercise: e.name,
                    target: e.description ?? 'Legs & Glutes',
                    instructions: e.instructions,
                  ),
                ),

                const SizedBox(height: 32),
                const _ProtocolSectionHeader(title: 'SHRED (Back & Core)'),
                const SizedBox(height: 16),
                ...WorkoutEngine.getExercisesForDay(3, {}).map(
                  (e) => ProtocolExpansionTile(
                    exercise: e.name,
                    target: e.description ?? 'Back & Core',
                    instructions: e.instructions,
                  ),
                ),

                const SizedBox(height: 48),

                // Philosophy Section
                const _ProtocolSectionHeader(title: 'The Philosophy'),
                const SizedBox(height: 16),

                const _PhilosophyCard(
                  text:
                      'The Saito-100 is not just a workout; it is a discipline. Each day is a step toward transformation. Consistency is the primary weapon of a Hero.',
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class ProtocolExpansionTile extends StatelessWidget {
  final String exercise;
  final String target;
  final String instructions;

  const ProtocolExpansionTile({
    super.key,
    required this.exercise,
    required this.target,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        duration: const Duration(milliseconds: 100),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: DesignSystem.cardDecoration(context),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  exercise,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TARGET: $target',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          instructions,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProtocolSectionHeader extends StatelessWidget {
  final String title;
  const _ProtocolSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        letterSpacing: 3,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

class _PhilosophyCard extends StatelessWidget {
  final String text;
  const _PhilosophyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: DesignSystem.cardDecoration(context),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.7,
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
