import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/features/drive/drive_connect_cubit.dart';

class CloudSyncPage extends StatelessWidget {
  final VoidCallback onContinue;

  const CloudSyncPage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<DriveConnectCubit, DriveConnectState>(
      listener: (context, state) {
        if (state is DriveConnected && !state.offlineOnly) {
          // Drive connected successfully!
          onContinue();
        }
      },
      child: Padding(
        padding: DesignSystem.pagePadding(DesignSystem.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 2),
            Text(
                  'Keep progress\nin the cloud',
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
                  'Connect your Google Drive to sync your workouts across devices. This is optional and private.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.15, curve: Curves.easeOut),
            const SizedBox(height: DesignSystem.spacingXL),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                child: Icon(
                  Symbols.cloud_done,
                  size: 64,
                  color: theme.colorScheme.primary,
                  weight: 600,
                ),
              ),
            ).animate().scale(
              delay: 400.ms,
              duration: 400.ms,
              curve: Curves.easeOutBack,
            ),
            const Spacer(flex: 3),
            BlocBuilder<DriveConnectCubit, DriveConnectState>(
              builder: (context, state) {
                final bool isConnecting = state is DriveConnecting;

                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isConnecting
                            ? null
                            : () => context.read<DriveConnectCubit>().connect(),
                        icon: isConnecting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Symbols.cloud_sync),
                        label: Text(
                          isConnecting
                              ? 'Connecting...'
                              : 'Connect Google Drive',
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    TextButton(
                      onPressed: isConnecting ? null : onContinue,
                      style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(double.infinity, 56),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: const Text('Continue Offline'),
                    ),
                  ],
                );
              },
            ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
