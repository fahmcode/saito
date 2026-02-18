import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/cubit/security_cubit.dart';
import 'package:saito/features/settings/security_lock.dart';

class SecurityPage extends StatelessWidget {
  final VoidCallback onContinue;
  const SecurityPage({super.key, required this.onContinue});

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
                'Protect your\nprogress',
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
                'Add a PIN or use biometrics to keep your '
                'workout data private.',
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SecurityLockScreen(
                    verifyPin: (pin) =>
                        context.read<SecurityCubit>().verifyPin(pin),
                    isSetup: true,
                    bioEnabled: true,
                    onResult: (success) {
                      if (success) {
                        Navigator.pop(context);
                        onContinue();
                      }
                    },
                    onPinSet: (pin) {
                      context.read<SecurityCubit>().enableSecurity(pin: pin);
                    },
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Enable Security'),
          ).animate().fadeIn(duration: 500.ms, delay: 500.ms),

          const SizedBox(height: 12),

          FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
            ),
            child: const Text('Skip for now'),
          ).animate().fadeIn(duration: 500.ms, delay: 580.ms),
        ],
      ),
    );
  }
}
