import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/config/design_system.dart';

import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/core/logic/cubit/preferences_cubit.dart';
import 'package:saito/features/onboarding/cloud_sync_page.dart';
import 'package:saito/features/onboarding/welcome_page.dart';
import 'package:saito/features/onboarding/calibration_intro_page.dart';
import 'package:saito/features/onboarding/baseline_picker_page.dart';
import 'package:saito/features/onboarding/security_page.dart';
import 'package:saito/features/onboarding/ready_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  static const _totalPages = 6;

  final ValueNotifier<int> _armor = ValueNotifier(20);
  final ValueNotifier<int> _foundation = ValueNotifier(20);
  final ValueNotifier<int> _shred = ValueNotifier(10);

  @override
  void dispose() {
    _controller.dispose();
    _armor.dispose();
    _foundation.dispose();
    _shred.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubicEmphasized,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    HapticFeedback.heavyImpact();
    context.read<WorkoutCubit>().saveBaselineReps({
      'armor': _armor.value,
      'foundation': _foundation.value,
      'shred': _shred.value,
    });
    context.read<PreferencesCubit>().setOnboardingComplete(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.appHorizontalPadding,
                vertical: DesignSystem.spacingS,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignSystem.radiusXS),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: (_page + 1) / _totalPages),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubicEmphasized,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 4,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  WelcomePage(onContinue: _next),
                  CloudSyncPage(onContinue: _next),
                  CalibrationIntroPage(onContinue: _next),
                  BaselinePickerPage(
                    armor: _armor,
                    foundation: _foundation,
                    shred: _shred,
                    onContinue: _next,
                  ),
                  SecurityPage(onContinue: _next),
                  ReadyPage(
                    armor: _armor,
                    foundation: _foundation,
                    shred: _shred,
                    onStart: _finish,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
