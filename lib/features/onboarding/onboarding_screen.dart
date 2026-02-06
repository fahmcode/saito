import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';
import 'package:saito/features/security/security_lock_screen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // State
  int _armorReps = 20;
  int _foundationReps = 20;
  int _shredReps = 10;

  void _nextStep() {
    if (_currentStep < 6) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: DesignSystem.durationMedium,
        curve: Curves.easeInOutCubicEmphasized,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    HapticFeedback.heavyImpact();
    final reps = {
      'armor': _armorReps,
      'foundation': _foundationReps,
      'shred': _shredReps,
    };
    context.read<UserProgressBloc>().add(SaveBaselineRepsEvent(reps));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentStep = index),
          children: [
            _WelcomeStep(onStart: _nextStep),
            _IntroStep(onStart: _nextStep),
            _RepSelectionStep(
              title: 'ARMOR',
              description: 'Max Diamond Push-ups',
              icon: Symbols.shield,
              value: _armorReps,
              onChanged: (v) => setState(() => _armorReps = v),
              onConfirm: _nextStep,
            ),
            _RepSelectionStep(
              title: 'FOUNDATION',
              description: 'Max Prisoner Squats',
              icon: Symbols.fitness_center,
              value: _foundationReps,
              onChanged: (v) => setState(() => _foundationReps = v),
              onConfirm: _nextStep,
            ),
            _RepSelectionStep(
              title: 'SHRED',
              description: 'Max Pull-ups',
              icon: Symbols.cyclone,
              value: _shredReps,
              onChanged: (v) => setState(() => _shredReps = v),
              onConfirm: _nextStep,
            ),
            _SecuritySetupStep(onNext: _nextStep),
            _SummaryStep(
              armor: _armorReps,
              foundation: _foundationReps,
              shred: _shredReps,
              onComplete: _finishOnboarding,
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onStart;
  const _WelcomeStep({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'WELCOME TO',
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 4,
              color: theme.colorScheme.outline,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
          const SizedBox(height: DesignSystem.spacingS),
          Text(
                'SAITO-100',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 150.ms)
              .scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: DesignSystem.spacingL),
          Text(
            'THE PATH TO ABSOLUTE STRENGTH',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onStart,
              style: FilledButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('GET STARTED'),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 450.ms),
        ],
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  final VoidCallback onStart;
  const _IntroStep({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        children: [
          const Spacer(),
          Container(
                padding: DesignSystem.pagePadding(DesignSystem.spacingL),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.surface),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: DesignSystem.spacingXXL),
          Text(
            'THE SAITO PROTOCOL',
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            'WE NEED YOUR CURRENT MAXIMUM CAPACITY TO CALIBRATE YOUR 100-DAY JOURNEY.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.1,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.tonal(
              onPressed: onStart,
              style: FilledButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('BEGIN CALIBRATION'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepSelectionStep extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onConfirm;

  const _RepSelectionStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.primary,
          ).animate().scale(duration: 400.ms, curve: Curves.bounceOut),
          const SizedBox(height: DesignSystem.spacingL),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 4),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          Text(
            description,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Text(
                '$value',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 120,
                  fontWeight: FontWeight.w200,
                  color: theme.colorScheme.onSurface,
                ),
              )
              .animate(key: ValueKey(value))
              .fade()
              .scale(begin: const Offset(0.9, 0.9)),
          const Spacer(),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: theme.colorScheme.primary,
            onChanged: (v) {
              if (v.toInt() != value) {
                HapticFeedback.selectionClick();
                onChanged(v.toInt());
              }
            },
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('CONFIRM BASELINE'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStep extends StatelessWidget {
  final int armor, foundation, shred;
  final VoidCallback onComplete;

  const _SummaryStep({
    required this.armor,
    required this.foundation,
    required this.shred,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: DesignSystem.spacingXXL),
          Text(
            'CALIBRATION\nCOMPLETE',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          _SummaryLine(label: 'ARMOR', value: armor),
          _SummaryLine(label: 'FOUNDATION', value: foundation),
          _SummaryLine(label: 'SHRED', value: shred),
          const Spacer(),
          Container(
            decoration: DesignSystem.cardDecoration(context),
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingL),
              child: Row(
                children: [
                  Icon(Icons.stars_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: DesignSystem.spacingM),
                  Text(
                    'INITIAL RANK: HUMAN',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onComplete,
              style: FilledButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('START DAY 1'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final int value;
  const _SummaryLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 2,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '$value',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySetupStep extends StatelessWidget {
  final VoidCallback onNext;

  const _SecuritySetupStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: DesignSystem.pagePadding(DesignSystem.spacingL),
      child: Column(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Icon(
              Symbols.lock,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'SECURE THE DOJO',
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            'PROTECT YOUR PROGRESS.\nENABLE PIN & BIOMETRIC SECURITY.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SecurityLockScreen(
                      isSetup: true,
                      bioEnabled: true,
                      onResult: (success) {
                        if (success) {
                          Navigator.pop(context);
                          onNext();
                        }
                      },
                      onPinSet: (pin) {
                        context.read<UserProgressBloc>().add(
                          UpdateSettingsEvent(
                            securityEnabled: true,
                            securityPin: pin,
                            lockDurationMinutes: 0,
                            biometricEnabled: true,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(shape: const StadiumBorder()),
              child: const Text('ENABLE SECURITY'),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
          const SizedBox(height: DesignSystem.spacingM),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onNext();
            },
            child: Text(
              'SKIP FOR NOW',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
        ],
      ),
    );
  }
}
