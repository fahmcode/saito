import 'package:flutter/material.dart';
import 'package:saito/core/config/design_system.dart';

class TermsServiceScreen extends StatelessWidget {
  const TermsServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Terms & Service'),
            centerTitle: false,
            scrolledUnderElevation: 0,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: theme.colorScheme.surface,
          ),
          SliverPadding(
            padding: DesignSystem.pagePadding(DesignSystem.spacingM),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildLegalSection(
                  context,
                  '1. Health Disclaimer',
                  'The Saito-100 training protocols are demanding. Consult a healthcare professional before starting any new exercise program. Users assume all risk associated with the performance of these exercises.',
                ),
                const SizedBox(height: 24),
                _buildLegalSection(
                  context,
                  '2. Local Storage',
                  'Saito-100 stores all progress data locally on your device. We do not transmit your training history to external servers. Clearing app data or deleting the app will result in the loss of all progress.',
                ),
                const SizedBox(height: 24),
                _buildLegalSection(
                  context,
                  '3. Usage Agreement',
                  'By using this application, you agree to follow the training protocols safely and within your physical limits. The app is provided "as is" without warranties of any kind.',
                ),
                const SizedBox(height: 24),
                _buildLegalSection(
                  context,
                  '4. Privacy Policy',
                  'Your privacy is paramount. Saito-100 does not collect personal identification information. Biometric data (Face ID/Fingerprint), if enabled, is handled entirely by your device\'s secure enclave.',
                ),
                const SizedBox(height: 40),
                Text(
                  'Last Updated: February 4, 2026',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
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

  Widget _buildLegalSection(
    BuildContext context,
    String title,
    String content,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
