import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/widgets/modern_app_bar.dart';

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
  String? _firstPin;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isSetup && widget.bioEnabled) {
      _authenticateBiometrically();
    }
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
      backgroundColor: theme.colorScheme.surface,
      appBar: widget.isSetup ? const ModernAppBar(title: 'Security') : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: DesignSystem.spacingXL),
              ExcludeSemantics(
                child: Icon(
                  widget.isSetup ? Symbols.security : Symbols.lock,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Text(
                widget.isSetup
                    ? (_isConfirming
                          ? 'Confirm your PIN'
                          : 'Set your security PIN')
                    : 'Unlock to use Baki',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                'Enter your PIN or use biometrics',
                style: theme.textTheme.bodyMedium?.copyWith(
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
              const SizedBox(height: DesignSystem.spacingXL),
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
    return Semantics(
      label: 'PIN entered: $length of 4 digits',
      child: Row(
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
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              );
            },
          );
        }),
      ),
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
              (d) => _KeyboardKey(
                label: d,
                semanticLabel: 'Digit $d',
                onPressed: () => onDigitPressed(d),
              ),
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
          semanticLabel: 'Use biometrics',
          onPressed: onBiometricPressed ?? () {},
          opacity: onBiometricPressed != null ? 1.0 : 0.0,
        ),
        _KeyboardKey(
          label: '0',
          semanticLabel: 'Digit 0',
          onPressed: () => onDigitPressed('0'),
        ),
        _KeyboardKey(
          icon: Symbols.backspace,
          semanticLabel: 'Delete last digit',
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
  final String semanticLabel;
  final VoidCallback onPressed;
  final double opacity;

  const _KeyboardKey({
    this.label,
    this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: opacity,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMax),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
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
