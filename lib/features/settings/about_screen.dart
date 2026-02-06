import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/core/config/design_system.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('About Saito-100'),
            centerTitle: false,
            scrolledUnderElevation: 0,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: theme.colorScheme.surface,
          ),
          SliverPadding(
            padding: DesignSystem.pagePadding(DesignSystem.spacingM),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoSection(
                  context,
                  'The Mission',
                  'Saito-100 is building the foundational strength of tomorrow\'s heroes. Our mission is to provide a zero-excuse, high-impact training framework that transforms both body and discipline over a 100-day cycle.',
                ),
                const SizedBox(height: 32),
                _buildInfoSection(
                  context,
                  'The Protocol',
                  'Inspired by legendary training regimes, Saito-100 utilizes a 4-day rotation (Armor, Foundation, Shred, Recovery) combined with an aggressive progressive overload engine focused on Volume, Intensity, Tempo, and Mastery.',
                ),
                const SizedBox(height: 32),
                _buildInfoSection(
                  context,
                  'Version',
                  'SAITO-100 v0.1.0 (Alpha)\nReleased: Feb 2026',
                ),
                const SizedBox(height: 48),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Symbols.shield_moon,
                        size: 48,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'FORGED IN THE DOJO',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 4,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
