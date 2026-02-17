import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;
  const WelcomePage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),

          Text(
                'Welcome to\nSaito-100',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: DesignSystem.spacingM),

          Text(
                'Your personal 100-day bodyweight strength program. '
                'We\'ll calibrate everything to your level.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const Spacer(flex: 3),

          FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Get Started'),
          ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
        ],
      ),
    );
  }
}
