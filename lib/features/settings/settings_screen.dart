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
