import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saito/features/home/home_screen.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/core/logic/cubit/preferences_cubit.dart';
import 'package:saito/core/logic/cubit/security_cubit.dart';
import 'package:saito/features/onboarding/onboarding_screen.dart';
import 'package:saito/features/settings/security_lock.dart';
import 'package:saito/core/data/repositories/app_repository.dart';

class SaitoApp extends StatefulWidget {
  final AppRepository repository;
  const SaitoApp({super.key, required this.repository});

  @override
  State<SaitoApp> createState() => _SaitoAppState();
}

class _SaitoAppState extends State<SaitoApp> with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _hasUnlockedThisSession = false;
  DateTime? _backgroundTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final security = context.read<SecurityCubit>().state.config;
      if (security.securityEnabled) {
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
    final config = context.read<SecurityCubit>().state.config;
    if (!config.securityEnabled) {
      setState(() {
        _isLocked = false;
        _hasUnlockedThisSession = false;
      });
      return;
    }

    if (_hasUnlockedThisSession && _backgroundTime == null) {
      return;
    }

    if (_backgroundTime != null) {
      final durationSinceBackground = DateTime.now().difference(
        _backgroundTime!,
      );
      final lockDuration = Duration(minutes: config.lockDurationMinutes);

      if (config.lockDurationMinutes == 0 ||
          durationSinceBackground >= lockDuration) {
        setState(() {
          _isLocked = true;
          _hasUnlockedThisSession = false;
        });
      }
      _backgroundTime = null;
    }
  }

  void _onUnlockSuccess() {
    setState(() {
      _isLocked = false;
      _hasUnlockedThisSession = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: widget.repository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WorkoutCubit(widget.repository)..load(),
          ),
          BlocProvider(
            create: (context) => PreferencesCubit(widget.repository)..load(),
          ),
          BlocProvider(
            create: (context) => SecurityCubit(widget.repository)..load(),
          ),
        ],
        child: BlocBuilder<PreferencesCubit, PreferencesState>(
          buildWhen: (prev, curr) =>
              prev.preferences.themeMode != curr.preferences.themeMode,
          builder: (context, state) {
            return MaterialApp(
              title: 'Saito-100',
              debugShowCheckedModeBanner: false,
              theme: _buildLightTheme(),
              darkTheme: _buildDarkTheme(),
              themeMode: _resolveThemeMode(state.preferences.themeMode),
              builder: (context, child) {
                return Stack(
                  children: [
                    if (child != null) child,
                    if (_isLocked &&
                        context
                            .read<SecurityCubit>()
                            .state
                            .config
                            .securityEnabled)
                      SecurityLockScreen(
                        correctPin: context
                            .read<SecurityCubit>()
                            .state
                            .config
                            .securityPin,
                        bioEnabled: context
                            .read<SecurityCubit>()
                            .state
                            .config
                            .biometricEnabled,
                        onResult: (success) {
                          if (success) _onUnlockSuccess();
                        },
                      ),
                  ],
                );
              },
              home: const _AppContainer(),
            );
          },
        ),
      ),
    );
  }

  ThemeMode _resolveThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
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
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignSystem.cleanWhite,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
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
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignSystem.pureBlack,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

class _AppContainer extends StatelessWidget {
  const _AppContainer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      buildWhen: (prev, curr) =>
          prev.preferences.onboardingComplete !=
          curr.preferences.onboardingComplete,
      builder: (context, state) {
        if (!state.preferences.onboardingComplete) {
          return const OnboardingScreen();
        }
        return const HomeScreen();
      },
    );
  }
}
