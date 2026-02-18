import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/widgets/modern_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityLockScreen extends StatefulWidget {
  final Future<bool> Function(String pin) verifyPin;
  final bool bioEnabled;
  final ValueChanged<bool> onResult;
  final ValueChanged<String>? onPinSet;
  final bool isSetup;

  const SecurityLockScreen({
    super.key,
    required this.verifyPin,
    this.bioEnabled = false,
    required this.onResult,
    this.onPinSet,
    this.isSetup = false,
  });

  @override
  State<SecurityLockScreen> createState() => _SecurityLockScreenState();
}

class _SecurityLockScreenState extends State<SecurityLockScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _auth = LocalAuthentication();
  String _currentPin = '';
  String? _firstPin;
  bool _isConfirming = false;

  int _failedAttempts = 0;
  DateTime? _nextRetryAt;
  Timer? _cooldownTimer;
  String? _statusMessage;
  bool _showError = false;
  SharedPreferences? _prefs;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeOutCubic),
        );

    if (!widget.isSetup && widget.bioEnabled) {
      _authenticateBiometrically();
    }
    _loadPersistedLock();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPersistedLock() async {
    _prefs = await SharedPreferences.getInstance();
    final attempts = _prefs?.getInt('security_failed_attempts') ?? 0;
    final nextTs = _prefs?.getInt('security_next_retry_at');
    setState(() {
      _failedAttempts = attempts;
      _nextRetryAt = nextTs != null
          ? DateTime.fromMillisecondsSinceEpoch(nextTs)
          : null;
    });
    if (_nextRetryAt != null && DateTime.now().isBefore(_nextRetryAt!)) {
      _startCooldownTimer();
      _statusMessage =
          'Try again in ${max(0, _nextRetryAt!.difference(DateTime.now()).inSeconds)}s';
      _showError = true;
    } else {
      _nextRetryAt = null;
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
        _resetAttempts(success: true);
      } else {
        _handleFailedAttempt();
      }
    } catch (_) {
      _handleFailedAttempt();
    }
  }

  void _handleDigitPress(String digit) {
    if (!_inputEnabled) return;
    if (_currentPin.length < 4) {
      setState(() => _currentPin += digit);
      HapticFeedback.mediumImpact(); // stronger feedback per key tap
      if (_currentPin.length == 4) _handlePinComplete(_currentPin);
    }
  }

  void _handleBackspace() {
    if (!_inputEnabled) return;
    if (_currentPin.isNotEmpty) {
      setState(
        () => _currentPin = _currentPin.substring(0, _currentPin.length - 1),
      );
      HapticFeedback.selectionClick();
    }
  }

  void _handlePinComplete(String pin) {
    Future.delayed(const Duration(milliseconds: 120), () async {
      if (!mounted) return;
      if (widget.isSetup) {
        if (!_isConfirming) {
          setState(() {
            _firstPin = pin;
            _isConfirming = true;
            _currentPin = '';
            _statusMessage = 'Confirm your PIN';
            _showError = false;
          });
          HapticFeedback.mediumImpact();
        } else {
          if (pin == _firstPin) {
            widget.onPinSet?.call(pin);
            widget.onResult(true);
            _resetAttempts(success: true);
          } else {
            _handleFailedAttempt(message: 'PINs do not match. Try again.');
            setState(() {
              _isConfirming = false;
              _firstPin = null;
              _currentPin = '';
            });
          }
        }
      } else {
        final ok = await widget.verifyPin(pin);
        if (ok) {
          widget.onResult(true);
          _resetAttempts(success: true);
        } else {
          _handleFailedAttempt();
          setState(() => _currentPin = '');
        }
      }
    });
  }

  void _handleFailedAttempt({String? message}) {
    HapticFeedback.heavyImpact();
    _failedAttempts += 1;
    final delay = _delayForAttempt(_failedAttempts);

    if (delay > Duration.zero) {
      _nextRetryAt = DateTime.now().add(delay);
      _startCooldownTimer();
      _statusMessage = message ?? 'Try again in ${delay.inSeconds}s';
    } else {
      _statusMessage = message ?? 'Incorrect PIN';
    }
    _showError = true;
    _shakeController
      ..reset()
      ..forward();
    HapticFeedback.vibrate();
    _persistLockState();
    setState(() {});
  }

  void _resetAttempts({bool success = false}) {
    _failedAttempts = 0;
    _nextRetryAt = null;
    _showError = false;
    _currentPin = '';
    _cooldownTimer?.cancel();
    _statusMessage = success ? 'Unlocked' : null;
    _persistLockState();
    setState(() {});
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _nextRetryAt == null) {
        _cooldownTimer?.cancel();
        return;
      }
      final remaining = _nextRetryAt!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _nextRetryAt = null;
        _statusMessage = null;
        _showError = false;
        _cooldownTimer?.cancel();
        _persistLockState();
      } else {
        _statusMessage = 'Try again in ${remaining}s';
        _persistLockState();
      }
      setState(() {});
    });
  }

  void _persistLockState() {
    _prefs?.setInt('security_failed_attempts', _failedAttempts);
    if (_nextRetryAt != null) {
      _prefs?.setInt(
        'security_next_retry_at',
        _nextRetryAt!.millisecondsSinceEpoch,
      );
    } else {
      _prefs?.remove('security_next_retry_at');
    }
  }

  Duration _delayForAttempt(int attempt) {
    if (attempt >= 5) return const Duration(seconds: 60);
    if (attempt == 4) return const Duration(seconds: 15);
    if (attempt == 3) return const Duration(seconds: 5);
    return Duration.zero;
  }

  bool get _inputEnabled =>
      _nextRetryAt == null || DateTime.now().isAfter(_nextRetryAt!);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = _nextRetryAt == null
        ? 0
        : max(0, _nextRetryAt!.difference(DateTime.now()).inSeconds);
    final status =
        _statusMessage ??
        (widget.isSetup
            ? (_isConfirming ? 'Confirm your PIN' : 'Set your security PIN')
            : 'Enter PIN or use Face ID/Touch ID');
    final bioLabel = Theme.of(context).platform == TargetPlatform.iOS
        ? 'Face ID'
        : 'Touch ID';

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
                widget.isSetup ? 'Set Passcode' : 'Unlock Baki',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: DesignSystem.spacingM),
              Text(
                status,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _showError
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline,
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: _PinDots(length: _currentPin.length, error: _showError),
              ),
              if (_nextRetryAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: DesignSystem.spacingS),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Try again in ${remaining}s',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _inputEnabled ? 1 : 0.45,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: _inputEnabled ? 1 : 0.98,
                  child: _PinKeyboard(
                    onDigitPressed: _handleDigitPress,
                    onBackspacePressed: _handleBackspace,
                    onBiometricPressed:
                        (!widget.isSetup && widget.bioEnabled && _inputEnabled)
                        ? _authenticateBiometrically
                        : null,
                    enabled: _inputEnabled,
                    bioLabel: bioLabel,
                  ),
                ),
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
  final bool error;
  const _PinDots({required this.length, this.error = false});

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
                        ? (error
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary)
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
  final bool enabled;
  final String bioLabel;

  const _PinKeyboard({
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
    this.enabled = true,
    required this.bioLabel,
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
                onPressed: enabled ? () => onDigitPressed(d) : null,
                enabled: enabled,
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
          semanticLabel: 'Use $bioLabel',
          label: onBiometricPressed != null ? bioLabel : null,
          onPressed: onBiometricPressed,
          opacity: onBiometricPressed != null ? 1.0 : 0.0,
          enabled: enabled && onBiometricPressed != null,
        ),
        _KeyboardKey(
          label: '0',
          semanticLabel: 'Digit 0',
          onPressed: enabled ? () => onDigitPressed('0') : null,
          enabled: enabled,
        ),
        _KeyboardKey(
          icon: Symbols.backspace,
          semanticLabel: 'Delete last digit',
          onPressed: enabled ? onBackspacePressed : null,
          opacity: 0.8,
          enabled: enabled,
        ),
      ],
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final double opacity;
  final bool enabled;

  const _KeyboardKey({
    this.label,
    this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.opacity = 1.0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: opacity,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: semanticLabel,
        child: _PressableKey(
          enabled: enabled,
          onPressed: onPressed,
          builder: (pressed) => AnimatedScale(
            duration: const Duration(milliseconds: 80),
            scale: pressed ? 0.96 : 1.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                highlightColor: theme.colorScheme.primary.withValues(
                  alpha: 0.04,
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: enabled ? 0.35 : 0.15,
                    ),
                  ),
                  child: label != null
                      ? Text(
                          label!,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: enabled
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                          ),
                        )
                      : Icon(
                          icon,
                          size: 28,
                          color: enabled
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.4,
                                ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PressableKey extends StatefulWidget {
  final Widget Function(bool pressed) builder;
  final VoidCallback? onPressed;
  final bool enabled;

  const _PressableKey({
    required this.builder,
    required this.onPressed,
    required this.enabled,
  });

  @override
  State<_PressableKey> createState() => _PressableKeyState();
}

class _PressableKeyState extends State<_PressableKey> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.enabled ? widget.onPressed : null,
      child: widget.builder(_pressed),
    );
  }
}
