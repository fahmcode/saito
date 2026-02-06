import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';
import 'package:saito/features/faq/hero_faq_screen.dart';
import 'package:saito/features/security/security_lock_screen.dart';
import 'package:saito/features/settings/about_screen.dart';
import 'package:saito/features/settings/terms_service_screen.dart';
import 'package:local_auth/local_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (context, state) {
        final progress = state.progress;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: const Text('Settings'),
                centerTitle: false,
                scrolledUnderElevation: 0,
                backgroundColor: theme.colorScheme.surface,
                surfaceTintColor: theme.colorScheme.surface,
              ),
              SliverPadding(
                padding: DesignSystem.pagePadding(DesignSystem.spacingM),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionHeader(context, 'PREFERENCES'),
                    _buildToggleTile(
                      context,
                      'Audio Effects',
                      'Play sounds during workout transitions',
                      progress.audioEnabled,
                      (v) {
                        HapticFeedback.lightImpact();
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(audioEnabled: v),
                        );
                      },
                    ),
                    _buildToggleTile(
                      context,
                      'Haptic Feedback',
                      'Physical touch feedback',
                      progress.hapticsEnabled,
                      (v) {
                        HapticFeedback.mediumImpact();
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(hapticsEnabled: v),
                        );
                      },
                    ),
                    _buildThemeSelector(
                      context,
                      'Theme Mode',
                      'Choose your preferred theme',
                      progress.themeMode,
                      (mode) {
                        HapticFeedback.mediumImpact();
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(themeMode: mode),
                        );
                      },
                    ),
                    const SizedBox(height: DesignSystem.spacingM),
                    const SizedBox(height: DesignSystem.spacingXL),
                    _buildSectionHeader(context, 'SECURITY'),
                    _buildToggleTile(
                      context,
                      'App Lock',
                      'Protect your progress with a PIN',
                      progress.securityEnabled,
                      (v) {
                        HapticFeedback.mediumImpact();
                        if (v) {
                          // Start PIN setup
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SecurityLockScreen(
                                isSetup: true,
                                onResult: (success) {
                                  if (success) {
                                    Navigator.pop(context);
                                  }
                                },
                                onPinSet: (pin) {
                                  context.read<UserProgressBloc>().add(
                                    UpdateSettingsEvent(
                                      securityEnabled: true,
                                      securityPin: pin,
                                    ),
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
                      },
                    ),
                    if (progress.securityEnabled) ...[
                      _buildLockDurationSelector(
                        context,
                        progress.lockDurationMinutes,
                      ),
                      _buildToggleTile(
                        context,
                        'Biometric Entry',
                        'Unlock using Fingerprint or Face ID',
                        progress.biometricEnabled,
                        (v) async {
                          HapticFeedback.mediumImpact();
                          if (v) {
                            final auth = LocalAuthentication();
                            final canCheck = await auth.canCheckBiometrics;
                            final isSupported = await auth.isDeviceSupported();

                            if (!canCheck || !isSupported) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Biometrics not available on this device.',
                                    ),
                                  ),
                                );
                              }
                              return;
                            }

                            try {
                              final authenticated = await auth.authenticate(
                                localizedReason:
                                    'Confirm biometrics to enable entry',
                                options: const AuthenticationOptions(
                                  stickyAuth: true,
                                  biometricOnly: true,
                                ),
                              );

                              if (authenticated && context.mounted) {
                                context.read<UserProgressBloc>().add(
                                  const UpdateSettingsEvent(
                                    biometricEnabled: true,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          } else {
                            context.read<UserProgressBloc>().add(
                              const UpdateSettingsEvent(
                                biometricEnabled: false,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: DesignSystem.spacingXL),
                    _buildSectionHeader(context, 'RESOURCES'),
                    _buildActionTile(
                      context,
                      'Hero FAQ',
                      'Learn exercise techniques and philosophy',
                      theme.colorScheme.primary,
                      () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HeroFaqScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionTile(
                      context,
                      'About Saito-100',
                      'Dojo mission and version info',
                      theme.colorScheme.secondary,
                      () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionTile(
                      context,
                      'Terms & Services',
                      'Legal disclaimer and privacy',
                      theme.colorScheme.outline,
                      () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TermsServiceScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: DesignSystem.spacingXL),
                    _buildSectionHeader(context, 'DANGER ZONE'),
                    _buildActionTile(
                      context,
                      'Reset All Progress',
                      'This action cannot be undone',
                      Colors.red,
                      () => _showResetConfirmation(context),
                    ),
                    const SizedBox(height: DesignSystem.spacingXL),
                    Center(
                      child: Text(
                        'SAITO-100 v0.1.0',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    String title,
    String subtitle,
    String currentMode,
    Function(String) onChanged,
  ) {
    final theme = Theme.of(context);
    final themeName = _getThemeName(currentMode);

    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),

      decoration: DesignSystem.cardDecoration(context),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingL,
          vertical: DesignSystem.spacingS,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              themeName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingS),
            Icon(
              Symbols.chevron_right,
              color: theme.colorScheme.outline,
              size: 20,
            ),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: theme.colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(DesignSystem.radiusL),
              ),
            ),
            builder: (sheetContext) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: DesignSystem.spacingM),
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
                      'Select Theme',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingL),
                    _buildThemeOption(
                      context,
                      'System Default',
                      'Follow device settings',
                      'system',
                      currentMode,
                      onChanged,
                    ),
                    _buildThemeOption(
                      context,
                      'Light Mode',
                      'Always use light theme',
                      'light',
                      currentMode,
                      onChanged,
                    ),
                    _buildThemeOption(
                      context,
                      'Dark Mode',
                      'Always use dark theme',
                      'dark',
                      currentMode,
                      onChanged,
                    ),
                    const SizedBox(height: DesignSystem.spacingL),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    String currentValue,
    Function(String) onChanged,
  ) {
    final theme = Theme.of(context);
    final isSelected = value == currentValue;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingXL,
        vertical: DesignSystem.spacingXS,
      ),
      leading: Icon(
        isSelected ? Symbols.check_circle : Symbols.circle,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        fill: isSelected ? 1 : 0,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () {
        onChanged(value);
        Navigator.pop(context);
      },
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.5,
          color: Theme.of(context).colorScheme.outline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      decoration: DesignSystem.cardDecoration(context),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      decoration: DesignSystem.cardDecoration(context),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLockDurationSelector(BuildContext context, int currentMinutes) {
    final theme = Theme.of(context);
    final levels = {
      0: 'Immediately',
      1: 'After 1 Minute',
      5: 'After 5 Minutes',
      15: 'After 15 Minutes',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      decoration: DesignSystem.cardDecoration(context),
      child: ListTile(
        title: const Text('Auto-Lock Duration'),
        subtitle: Text('Current: ${levels[currentMinutes]}'),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: theme.colorScheme.surfaceContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(DesignSystem.radiusL),
              ),
            ),
            builder: (context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(DesignSystem.spacingL),
                    child: Text(
                      'Auto-Lock Duration',
                      style: theme.textTheme.labelLarge?.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  ...levels.entries.map((e) {
                    return ListTile(
                      title: Text(e.value),
                      onTap: () {
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(lockDurationMinutes: e.key),
                        );
                        Navigator.pop(context);
                      },
                      trailing: currentMinutes == e.key
                          ? Icon(Icons.check, color: theme.colorScheme.primary)
                          : null,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<UserProgressBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'RESET PROGRESS?',
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                'Are you sure you want to delete all training data and restart from Day 1? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingL),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    bloc.add(ResetProgressEvent());
                    Navigator.pop(context); // Close sheet
                    Navigator.pop(context); // Exit settings
                  },
                  child: const Text('RESET EVERYTHING'),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingS),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
