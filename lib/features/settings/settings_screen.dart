import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/widgets/modern_app_bar.dart';
import 'package:saito/widgets/settings_widgets.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/features/settings/security_lock.dart';
import 'package:saito/core/logic/cubit/security_cubit.dart';
import 'package:saito/core/logic/cubit/preferences_cubit.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/features/drive/drive_connect_cubit.dart';
import 'package:saito/core/data/sources/sync_service.dart'
    show DriveSyncService, SyncState, SyncStatus;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const ModernAppBar(title: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: DesignSystem.pagePadding(DesignSystem.spacingXL),
          children: [
            _buildCloudSection(context),
            _buildEffectsSection(context),
            _buildSecuritySection(context),
            _buildPreferencesSection(context),
            _buildDangerSection(context),
            const SizedBox(height: DesignSystem.spacingXXL),
          ],
        ),
      ),
    );
  }

  Widget _buildCloudSection(BuildContext context) {
    return BlocBuilder<DriveConnectCubit, DriveConnectState>(
      builder: (context, state) {
        if (state is DriveConnected && !state.offlineOnly) {
          final sync = context.read<DriveSyncService>();
          return ValueListenableBuilder<SyncState>(
            valueListenable: sync.state,
            builder: (context, syncState, _) {
              final theme = Theme.of(context);
              final statusLabel = switch (syncState.status) {
                SyncStatus.syncing => 'Syncing…',
                SyncStatus.backoff => 'Retry in ${syncState.backoffSeconds}s',
                SyncStatus.error => 'Error',
                _ => 'Idle',
              };
              final statusColor = switch (syncState.status) {
                SyncStatus.syncing => theme.colorScheme.primary,
                SyncStatus.backoff => theme.colorScheme.tertiary,
                SyncStatus.error => theme.colorScheme.error,
                _ => theme.colorScheme.onSurfaceVariant,
              };
              final lastSync = syncState.lastSyncAt != null
                  ? 'Last sync: ${syncState.lastSyncAt}'
                  : 'Not synced yet';

              return SettingsGroup(
                title: 'CLOUD SYNC',
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                DesignSystem.spacingM,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(
                                  DesignSystem.radiusM,
                                ),
                              ),
                              child: Icon(
                                Symbols.cloud_done,
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
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.email ?? 'Connected',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                statusLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DesignSystem.spacingM),
                        Text(
                          lastSync,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (syncState.error != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: DesignSystem.spacingS,
                            ),
                            child: Text(
                              syncState.error!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        const SizedBox(height: DesignSystem.spacingS),
                        Row(
                          children: [
                            FilledButton.tonal(
                              onPressed:
                                  (syncState.status == SyncStatus.backoff ||
                                      syncState.status == SyncStatus.syncing)
                                  ? null
                                  : () async {
                                      await sync.sync(state.accountId);
                                      if (context.mounted &&
                                          sync.state.value.status ==
                                              SyncStatus.idle) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Sync complete'),
                                          ),
                                        );
                                      }
                                    },
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Sync now',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: DesignSystem.spacingM),
                            Text(
                              'Pending: ${syncState.pendingCount}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SettingsTile(
                    icon: Symbols.logout,
                    title: 'Disconnect Drive',
                    iconColor: theme.colorScheme.error,
                    onTap: () => context.read<DriveConnectCubit>().disconnect(),
                  ),
                ],
              );
            },
          );
        }

        return SettingsGroup(
          title: 'CLOUD SYNC',
          children: [
            SettingsTile(
              icon: Symbols.cloud_sync,
              title: 'Not Connected',
              subtitle: 'Back up workouts to Google Drive',
              onTap: () => context.read<DriveConnectCubit>().connect(),
            ),
            SettingsTile(
              icon: Symbols.offline_pin,
              title: 'Offline Mode',
              subtitle: 'Use this device only',
              trailing: Switch(
                value: state is DriveConnected && state.offlineOnly,
                onChanged: (v) {
                  if (v) {
                    context.read<DriveConnectCubit>().useOfflineOnly();
                  } else {
                    context.read<DriveConnectCubit>().connect();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEffectsSection(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        final prefs = state.preferences;
        return SettingsGroup(
          title: 'EFFECTS',
          children: [
            SettingsSwitchTile(
              icon: Symbols.volume_up,
              title: 'Audio FX',
              subtitle: 'In-workout sound effects',
              value: prefs.audioEnabled,
              onChanged: (v) =>
                  context.read<PreferencesCubit>().setAudioEnabled(v),
            ),
            SettingsSwitchTile(
              icon: Symbols.vibration,
              title: 'Haptic Feedback',
              subtitle: 'Tactile responses',
              value: prefs.hapticsEnabled,
              onChanged: (v) =>
                  context.read<PreferencesCubit>().setHapticsEnabled(v),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return BlocBuilder<SecurityCubit, SecurityState>(
      builder: (context, state) {
        final config = state.config;
        return SettingsGroup(
          title: 'SECURITY',
          children: [
            SettingsSwitchTile(
              icon: Symbols.lock,
              title: 'App Lock',
              subtitle: 'Require PIN to open',
              value: config.securityEnabled,
              onChanged: (v) {
                if (v) {
                  _showPinSetup(context);
                } else {
                  context.read<SecurityCubit>().disableSecurity();
                }
              },
            ),
            if (config.securityEnabled) ...[
              SettingsTile(
                icon: Symbols.timer,
                title: 'Auto Lock',
                subtitle: _lockDurationText(config.lockDurationMinutes),
                onTap: () => _showLockDurationPicker(context),
              ),
              SettingsSwitchTile(
                icon: Symbols.fingerprint,
                title: 'Biometrics',
                subtitle: 'Use fingerprint / face',
                value: config.biometricEnabled,
                onChanged: (v) async {
                  if (v) {
                    final auth = LocalAuthentication();
                    final canCheck = await auth.canCheckBiometrics;
                    final isSupported = await auth.isDeviceSupported();
                    if (!canCheck || !isSupported) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Biometrics not available on this device',
                            ),
                          ),
                        );
                      }
                      return;
                    }
                  }
                  if (context.mounted) {
                    context.read<SecurityCubit>().setBiometricEnabled(v);
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        final prefs = state.preferences;
        return SettingsGroup(
          title: 'PREFERENCES',
          children: [
            SettingsTile(
              icon: Symbols.palette,
              title: 'Appearance',
              subtitle: _themeDisplayText(prefs.themeMode),
              onTap: () => _showThemePicker(context, prefs.themeMode),
            ),
            const SettingsTile(
              icon: Symbols.info,
              title: 'Version',
              subtitle: '1.0.0',
              trailing: SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDangerSection(BuildContext context) {
    return SettingsGroup(
      title: 'DANGER ZONE',
      children: [
        SettingsTile(
          icon: Symbols.delete_forever,
          title: 'Reset All Progress',
          iconColor: Theme.of(context).colorScheme.error,
          onTap: () => _showResetConfirmation(context),
        ),
      ],
    );
  }

  String _lockDurationText(int minutes) {
    if (minutes == 0) return 'Immediately';
    if (minutes == 1) return 'After 1 minute';
    return 'After $minutes minutes';
  }

  String _themeDisplayText(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  void _showPinSetup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SecurityLockScreen(
          verifyPin: (pin) => context.read<SecurityCubit>().verifyPin(pin),
          isSetup: true,
          onResult: (success) {
            if (success) Navigator.pop(context);
          },
          onPinSet: (pin) {
            context.read<SecurityCubit>().enableSecurity(pin: pin);
          },
        ),
      ),
    );
  }

  void _showLockDurationPicker(BuildContext context) {
    final theme = Theme.of(context);
    final options = [
      {'label': 'Immediately', 'value': 0},
      {'label': 'After 1 minute', 'value': 1},
      {'label': 'After 5 minutes', 'value': 5},
      {'label': 'After 15 minutes', 'value': 15},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              Text(
                'Auto Lock',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              ...options.map((option) {
                return ListTile(
                  title: Text(option['label'] as String),
                  onTap: () {
                    context.read<SecurityCubit>().setLockDuration(
                      option['value'] as int,
                    );
                    Navigator.pop(sheetContext);
                  },
                );
              }),
              const SizedBox(height: DesignSystem.spacingM),
            ],
          ),
        );
      },
    );
  }

  void _showThemePicker(BuildContext context, String currentMode) {
    final theme = Theme.of(context);
    final options = [
      {'label': 'System', 'value': 'system'},
      {'label': 'Light', 'value': 'light'},
      {'label': 'Dark', 'value': 'dark'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              Text(
                'Appearance',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              ...options.map((option) {
                final isSelected = currentMode == option['value'];
                return ListTile(
                  title: Text(option['label'] as String),
                  trailing: isSelected
                      ? Icon(Symbols.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    context.read<PreferencesCubit>().setThemeMode(
                      option['value'] as String,
                    );
                    Navigator.pop(sheetContext);
                  },
                );
              }),
              const SizedBox(height: DesignSystem.spacingM),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Progress?'),
          content: const Text(
            'This will permanently delete all workout data. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () {
                context.read<WorkoutCubit>().resetProgress();
                Navigator.pop(dialogContext);
                Navigator.pop(context);
                HapticFeedback.heavyImpact();
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: const Text('RESET'),
            ),
          ],
        );
      },
    );
  }
}
