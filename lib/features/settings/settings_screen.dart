import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/widgets/settings_widgets.dart';
import 'package:saito/widgets/modern_app_bar.dart';
import 'package:saito/features/settings/security_lock.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (context, state) {
        final progress = state.progress;

        return Scaffold(
          appBar: const ModernAppBar(title: 'Settings'),
          backgroundColor: theme.colorScheme.surface,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.spacingL,
            ),
            child: Column(
              children: [
                SettingsProfileHeader(
                  name: 'GX Force',
                  username: 'gxforce430',
                  onEditTap: () {},
                ),

                SettingsGroup(
                  title: 'Effects',
                  children: [
                    SettingsSwitchTile(
                      icon: Symbols.volume_up,
                      title: 'Audio Effects',
                      subtitle: 'Play sounds during workout transitions',
                      value: progress.audioEnabled,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(audioEnabled: v),
                        );
                      },
                    ),
                    SettingsSwitchTile(
                      icon: Symbols.vibration,
                      title: 'Haptic Feedback',
                      subtitle: 'Physical touch feedback',
                      value: progress.hapticsEnabled,
                      onChanged: (v) {
                        HapticFeedback.mediumImpact();
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(hapticsEnabled: v),
                        );
                      },
                    ),
                  ],
                ),

                SettingsGroup(
                  title: 'Security',
                  children: [
                    SettingsSwitchTile(
                      icon: Symbols.lock,
                      title: 'App Lock',
                      subtitle: 'Protect your progress with a PIN',
                      value: progress.securityEnabled,
                      onChanged: (v) => _handleSecurityToggle(context, v),
                    ),
                    if (progress.securityEnabled) ...[
                      SettingsTile(
                        icon: Symbols.timer,
                        title: 'Auto-Lock Duration',
                        subtitle: _getLockDurationLabel(
                          progress.lockDurationMinutes,
                        ),
                        onTap: () => _showLockDurationSelector(
                          context,
                          progress.lockDurationMinutes,
                        ),
                      ),
                      SettingsSwitchTile(
                        icon: Symbols.fingerprint,
                        title: 'Biometric Entry',
                        subtitle: 'Unlock using Fingerprint or Face ID',
                        value: progress.biometricEnabled,
                        onChanged: (v) => _handleBiometricToggle(context, v),
                      ),
                    ],
                  ],
                ),

                SettingsGroup(
                  title: 'Preferences',
                  children: [
                    SettingsTile(
                      icon: Symbols.palette,
                      title: 'Appearance',
                      subtitle: _getThemeName(progress.themeMode),
                      onTap: () =>
                          _showThemeSelector(context, progress.themeMode),
                    ),
                    SettingsTile(
                      icon: Symbols.info,
                      title: 'Version',
                      trailing: Text(
                        '0.1.0',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DesignSystem.spacingXXL),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSecurityToggle(BuildContext context, bool enabled) {
    HapticFeedback.mediumImpact();
    if (enabled) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SecurityLockScreen(
            isSetup: true,
            onResult: (success) {
              if (success) Navigator.pop(context);
            },
            onPinSet: (pin) {
              context.read<UserProgressBloc>().add(
                UpdateSettingsEvent(securityEnabled: true, securityPin: pin),
              );
            },
          ),
        ),
      );
    } else {
      context.read<UserProgressBloc>().add(
        const UpdateSettingsEvent(securityEnabled: false),
      );
    }
  }

  Future<void> _handleBiometricToggle(
    BuildContext context,
    bool enabled,
  ) async {
    HapticFeedback.mediumImpact();
    if (enabled) {
      final auth = LocalAuthentication();
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometrics not available on this device.'),
            ),
          );
        }
        return;
      }

      try {
        final authenticated = await auth.authenticate(
          localizedReason: 'Confirm biometrics to enable entry',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (authenticated && context.mounted) {
          context.read<UserProgressBloc>().add(
            const UpdateSettingsEvent(biometricEnabled: true),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    } else {
      context.read<UserProgressBloc>().add(
        const UpdateSettingsEvent(biometricEnabled: false),
      );
    }
  }

  void _showThemeSelector(BuildContext context, String currentMode) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: DesignSystem.spacingL),
            _buildThemeOption(context, 'System Default', 'system', currentMode),
            _buildThemeOption(context, 'Light Mode', 'light', currentMode),
            _buildThemeOption(context, 'Dark Mode', 'dark', currentMode),
            const SizedBox(height: DesignSystem.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String value,
    String current,
  ) {
    final isSelected = value == current;
    return ListTile(
      leading: Icon(
        isSelected ? Symbols.check_circle : Symbols.circle,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
        fill: isSelected ? 1 : 0,
      ),
      title: Text(title),
      onTap: () {
        context.read<UserProgressBloc>().add(
          UpdateSettingsEvent(themeMode: value),
        );
        Navigator.pop(context);
      },
    );
  }

  void _showLockDurationSelector(BuildContext context, int current) {
    final theme = Theme.of(context);
    final levels = {
      0: 'Immediately',
      1: '1 Minute',
      5: '5 Minutes',
      15: '15 Minutes',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: DesignSystem.spacingL),
            ...levels.entries.map(
              (e) => ListTile(
                title: Text(e.value),
                trailing: current == e.key
                    ? Icon(Icons.check, color: theme.colorScheme.primary)
                    : null,
                onTap: () {
                  context.read<UserProgressBloc>().add(
                    UpdateSettingsEvent(lockDurationMinutes: e.key),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: DesignSystem.spacingL),
          ],
        ),
      ),
    );
  }

  String _getThemeName(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  String _getLockDurationLabel(int minutes) {
    if (minutes == 0) return 'Immediately';
    return 'After $minutes Minutes';
  }
}
