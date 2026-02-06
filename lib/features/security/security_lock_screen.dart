import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SecurityLockScreen extends StatefulWidget {
  final String? correctPin;
  final bool bioEnabled;
  final ValueChanged<bool> onResult;
  final ValueChanged<String>? onPinSet;
  final bool isSetup;

  const SecurityLockScreen({
    super.key,
    this.correctPin,
    this.bioEnabled = false,
    required this.onResult,
    this.onPinSet,
    this.isSetup = false,
  });

  @override
  State<SecurityLockScreen> createState() => _SecurityLockScreenState();
}

class _SecurityLockScreenState extends State<SecurityLockScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  String _currentPin = '';
  String? _firstPin; // For setup confirmation
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isSetup && widget.bioEnabled) {
      _authenticateBiometrically();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _authenticateBiometrically() async {
    final bool canCheck = await _auth.canCheckBiometrics;
    final bool isSupported = await _auth.isDeviceSupported();

    if (!canCheck || !isSupported) return;

    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to enter the Dojo',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (didAuthenticate) {
        widget.onResult(true);
      }
    } catch (_) {}
  }

  void _handleDigitPress(String digit) {
    if (_currentPin.length < 4) {
      setState(() => _currentPin += digit);
      if (Theme.of(context).platform == TargetPlatform.iOS ||
          Theme.of(context).platform == TargetPlatform.android) {
        HapticFeedback.lightImpact();
      }
      if (_currentPin.length == 4) {
        _handlePinComplete(_currentPin);
      }
    }
  }

  void _handleBackspace() {
    if (_currentPin.isNotEmpty) {
      setState(
        () => _currentPin = _currentPin.substring(0, _currentPin.length - 1),
      );
      HapticFeedback.selectionClick();
    }
  }

  void _handlePinComplete(String pin) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      if (widget.isSetup) {
        if (!_isConfirming) {
          setState(() {
            _firstPin = pin;
            _isConfirming = true;
            _currentPin = '';
          });
          HapticFeedback.mediumImpact();
        } else {
          if (pin == _firstPin) {
            widget.onPinSet?.call(pin);
            widget.onResult(true);
          } else {
            HapticFeedback.heavyImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PINs do not match. Try again.')),
            );
            setState(() {
              _isConfirming = false;
              _firstPin = null;
              _currentPin = '';
            });
          }
        }
      } else {
        if (pin == widget.correctPin) {
          widget.onResult(true);
        } else {
          HapticFeedback.heavyImpact();
          setState(() => _currentPin = '');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Incorrect PIN')));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: DesignSystem.pagePadding(DesignSystem.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isSetup ? Symbols.security : Symbols.lock,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Text(
                widget.isSetup
                    ? (_isConfirming
                          ? 'CONFIRM YOUR PIN'
                          : 'SET YOUR SECURITY PIN')
                    : 'ENTER YOUR PIN',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                'YOUR TRAINING DATA IS PROTECTED',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const Spacer(),
              _PinDots(length: _currentPin.length),
              const Spacer(),
              _PinKeyboard(
                onDigitPressed: _handleDigitPress,
                onBackspacePressed: _handleBackspace,
                onBiometricPressed: (!widget.isSetup && widget.bioEnabled)
                    ? _authenticateBiometrically
                    : null,
              ),
              const SizedBox(height: DesignSystem.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  final int length;
  const _PinDots({required this.length});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < length;
        return TweenAnimationBuilder<double>(
          key: ValueKey('dot_${index}_$length'),
          tween: Tween<double>(begin: isActive ? 0.8 : 1.0, end: 1.0),
          duration: isActive ? DesignSystem.durationFast : Duration.zero,
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: DesignSystem.durationFast,
                margin: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingS,
                ),
                width: DesignSystem.spacingM,
                height: DesignSystem.spacingM,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                    width: 1,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _PinKeyboard extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricPressed;

  const _PinKeyboard({
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          _buildKeyboardRow(context, row),
        _buildBottomRow(context),
      ],
    );
  }

  Widget _buildKeyboardRow(BuildContext context, List<String> digits) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: digits
            .map(
              (d) => _KeyboardKey(label: d, onPressed: () => onDigitPressed(d)),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _KeyboardKey(
          icon: onBiometricPressed != null ? Symbols.fingerprint : null,
          onPressed: onBiometricPressed ?? () {},
          opacity: onBiometricPressed != null ? 1.0 : 0.0,
        ),
        _KeyboardKey(label: '0', onPressed: () => onDigitPressed('0')),
        _KeyboardKey(
          icon: Symbols.backspace,
          onPressed: onBackspacePressed,
          opacity: 0.8,
        ),
      ],
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final double opacity;

  const _KeyboardKey({
    this.label,
    this.icon,
    required this.onPressed,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: opacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMax),
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
              ),
            ),
            child: label != null
                ? Text(
                    label!,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                : Icon(
                    icon,
                    size: 28,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
          ),
        ),
      ),
    );
  }
}
