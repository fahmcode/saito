import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/features/drive/drive_connect_cubit.dart';

class ConnectDriveScreen extends StatelessWidget {
  final String? error;
  final Object? errorDetails;
  const ConnectDriveScreen({super.key, this.error, this.errorDetails});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: DesignSystem.pagePadding(DesignSystem.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DesignSystem.spacingL),
              Text(
                'Cloud Sync',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingS),
              Text(
                'Keep your workouts safe in Google Drive. Simple, private, and recoverable.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.92, end: 1),
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(
                            DesignSystem.radiusM,
                          ),
                        ),
                        child: Icon(
                          Symbols.cloud_sync,
                          size: 28,
                          color: theme.colorScheme.primary,
                          weight: 600,
                        ),
                      ),
                      const SizedBox(width: DesignSystem.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Google Drive',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Private appData storage • encrypted in transit',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: error == null
                    ? const SizedBox.shrink()
                    : Container(
                        key: ValueKey(error),
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Symbols.error,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    error!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (errorDetails != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                errorDetails.toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      debugPrint('ConnectDriveScreen: Connect button tapped');
                      context.read<DriveConnectCubit>().connect();
                    },
                    icon: const Icon(Symbols.cloud_done),
                    label: const Text(
                      'Connect Google Drive',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: DesignSystem.spacingM,
                      ),
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingS),
                  TextButton(
                    onPressed: () =>
                        context.read<DriveConnectCubit>().useOfflineOnly(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: theme.colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue Offline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
