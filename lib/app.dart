import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saito/features/home/home_screen.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/bloc/user_progress_bloc.dart';
import 'package:saito/features/onboarding/onboarding_screen.dart';
import 'package:saito/features/security/security_lock_screen.dart';

class SaitoApp extends StatefulWidget {
  const SaitoApp({super.key});

  @override
  State<SaitoApp> createState() => _SaitoAppState();
}

class _SaitoAppState extends State<SaitoApp> with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _hasUnlockedThisSession = false; // Track if user has unlocked
  DateTime? _backgroundTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize lock status based on security settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = context.read<UserProgressBloc>().state.progress;
      if (progress.securityEnabled) {
        setState(() => _isLocked = true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _checkLockStatus();
    }
  }

  void _checkLockStatus() {
    final progress = context.read<UserProgressBloc>().state.progress;
    if (!progress.securityEnabled) {
      setState(() {
        _isLocked = false;
        _hasUnlockedThisSession = false;
      });
      return;
    }

    // If user has unlocked this session and we have no background time,
    // don't re-lock (this happens right after successful authentication)
    if (_hasUnlockedThisSession && _backgroundTime == null) {
      return;
    }

    // If we have background time, check if we should lock
    if (_backgroundTime != null) {
      final durationSinceBackground = DateTime.now().difference(
        _backgroundTime!,
      );
      final lockDuration = Duration(minutes: progress.lockDurationMinutes);

      // For immediate lock (0 minutes) or if duration has passed, lock the app
      if (progress.lockDurationMinutes == 0 ||
          durationSinceBackground >= lockDuration) {
        setState(() {
          _isLocked = true;
          _hasUnlockedThisSession = false; // Reset session on lock
        });
      }
      _backgroundTime = null;
    }
  }

  void _onUnlockSuccess() {
    setState(() {
      _isLocked = false;
      _hasUnlockedThisSession = true; // Mark as unlocked for this session
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProgressBloc, UserProgressState>(
      builder: (context, state) {
        final themeMode = _getThemeMode(state.progress.themeMode);

        return MaterialApp(
          title: 'SAITO-100',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: DesignSystem.cleanWhite,
            colorScheme: ColorScheme.fromSeed(
              seedColor: DesignSystem.saitoRed,
              brightness: Brightness.light,
              primary: DesignSystem.saitoRed,
              surface: DesignSystem.offWhite,
              surfaceContainer: Colors.white,
              surfaceContainerHighest: const Color(0xFFEEEEEE),
              onSurface: DesignSystem.offBlack,
              onPrimary: DesignSystem.cleanWhite,
              onSecondary: DesignSystem.cleanWhite,
            ),
            useMaterial3: true,
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                foregroundColor: DesignSystem.cleanWhite,
                backgroundColor: DesignSystem.saitoRed,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignSystem.saitoRed,
                side: const BorderSide(color: DesignSystem.saitoRed),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: DesignSystem.saitoRed,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: DesignSystem.cleanWhite,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: DesignSystem.pureBlack,
            colorScheme: ColorScheme.fromSeed(
              seedColor: DesignSystem.saitoRed,
              brightness: Brightness.dark,
              primary: DesignSystem.saitoRed,
              surface: DesignSystem.offBlack,
              surfaceContainer: DesignSystem.darkGray,
              surfaceContainerHighest: const Color(0xFF2C2C2C),
              onSurface: DesignSystem.cleanWhite,
              onPrimary: DesignSystem.cleanWhite,
              onSecondary: DesignSystem.cleanWhite,
            ),
            useMaterial3: true,
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                foregroundColor: DesignSystem.cleanWhite,
                backgroundColor: DesignSystem.saitoRed,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignSystem.cleanWhite,
                side: const BorderSide(color: DesignSystem.cleanWhite),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: DesignSystem.cleanWhite,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: DesignSystem.pureBlack,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          themeMode: themeMode,
          home: BlocBuilder<UserProgressBloc, UserProgressState>(
            builder: (context, state) {
              final progress = state.progress;

              if (progress.securityEnabled && _isLocked) {
                return SecurityLockScreen(
                  correctPin: progress.securityPin,
                  bioEnabled: progress.biometricEnabled,
                  onResult: (success) {
                    if (success) {
                      _onUnlockSuccess();
                    }
                  },
                );
              }

              if (!progress.hasSetBaseline) {
                return const OnboardingScreen();
              }
              return const HomeScreen();
            },
          ),
        );
      },
    );
  }

  ThemeMode _getThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
