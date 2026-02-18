import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saito/core/config/design_system.dart';
import 'package:saito/core/data/repositories/app_repository.dart';
import 'package:saito/core/data/sources/database.dart';
import 'package:saito/core/data/sources/sync_service.dart';
import 'package:saito/core/logic/cubit/preferences_cubit.dart';
import 'package:saito/core/logic/cubit/security_cubit.dart';
import 'package:saito/core/logic/cubit/workout_cubit.dart';
import 'package:saito/features/drive/connect_drive_screen.dart';
import 'package:saito/features/drive/drive_connect_cubit.dart';
import 'package:saito/features/home/home_screen.dart';
import 'package:saito/features/onboarding/onboarding_screen.dart';
import 'package:saito/features/settings/security_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saito/widgets/blocking_splash.dart';

class SaitoApp extends StatefulWidget {
  final AppDatabase db;
  final SharedPreferences prefs;

  const SaitoApp({super.key, required this.db, required this.prefs});

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Immediate lock when security is enabled
      setState(() {
        _isLocked = true;
        _hasUnlockedThisSession = false;
        _backgroundTime = DateTime.now();
      });
    } else if (state == AppLifecycleState.resumed) {
      _checkLockStatus();
    }
  }

  void _checkLockStatus() {
    setState(() {});
  }

  void _onUnlockSuccess() {
    setState(() {
      _isLocked = false;
      _hasUnlockedThisSession = true;
    });
  }

  Future<void> _migrateLocalWorkouts(String accountId) async {
    if (accountId == 'local') return;

    final localRows = await (widget.db.select(
      widget.db.workoutProgressTable,
    )..where((t) => t.userId.equals('local'))).get();
    if (localRows.isEmpty) return;

    final existing = await (widget.db.select(
      widget.db.workoutProgressTable,
    )..where((t) => t.userId.equals(accountId))).get();
    if (existing.isNotEmpty) return;

    for (final row in localRows) {
      await widget.db
          .into(widget.db.workoutProgressTable)
          .insertOnConflictUpdate(
            WorkoutProgressTableCompanion(
              id: Value(row.id),
              userId: Value(accountId),
              currentDay: Value(row.currentDay),
              streak: Value(row.streak),
              lastWorkoutDate: Value(row.lastWorkoutDate),
              dailyVolume: Value(row.dailyVolume),
              baselineReps: Value(row.baselineReps),
              hasSetBaseline: Value(row.hasSetBaseline),
              startDate: Value(row.startDate),
              createdAt: Value(row.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriveConnectCubit(),
      child: BlocBuilder<DriveConnectCubit, DriveConnectState>(
        builder: (context, driveState) {
          final bool isWaiting = driveState is DriveConnecting;

          if (isWaiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: BlockingSplash(message: 'Connecting to Drive...'),
            );
          }

          // Use local fallback if not connected
          final String userId = driveState is DriveConnected
              ? driveState.accountId
              : 'local';
          final bool offlineOnly = driveState is DriveConnected
              ? driveState.offlineOnly
              : true;

          final driveSync = (driveState is DriveConnected && !offlineOnly)
              ? DriveSyncService(
                  widget.db,
                  context.read<DriveConnectCubit>().signIn,
                )
              : null;

          final repository = AppRepository(
            db: widget.db,
            userId: userId,
            prefs: widget.prefs,
            sync: driveSync,
          );

          // Trigger initial sync when online
          if (driveSync != null) {
            _migrateLocalWorkouts(
              userId,
            ).then((_) => driveSync.sync(userId).catchError((_) {}));
          }

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: repository),
              if (driveSync != null)
                RepositoryProvider<DriveSyncService>.value(value: driveSync),
            ],
            child: MultiBlocProvider(
              key: ValueKey(userId),
              providers: [
                BlocProvider(
                  create: (context) => WorkoutCubit(repository)..load(),
                ),
                BlocProvider(
                  create: (context) => PreferencesCubit(repository)..load(),
                ),
                BlocProvider(
                  create: (context) => SecurityCubit(repository)..load(),
                ),
              ],
              child: BlocBuilder<PreferencesCubit, PreferencesState>(
                buildWhen: (prev, curr) =>
                    prev.preferences.themeMode != curr.preferences.themeMode,
                builder: (context, state) {
                  final securityState = context.watch<SecurityCubit>().state;
                  final securityConfig = securityState.config;

                  return MaterialApp(
                    title: 'Saito-100',
                    debugShowCheckedModeBanner: false,
                    theme: _buildLightTheme(),
                    darkTheme: _buildDarkTheme(),
                    themeMode: _resolveThemeMode(state.preferences.themeMode),
                    builder: (context, child) {
                      // Handle initial lock state if enabled
                      if (securityState.loaded &&
                          securityConfig.securityEnabled &&
                          !_hasUnlockedThisSession &&
                          !_isLocked) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => _isLocked = true);
                        });
                      }

                      // Handle background lock timer
                      if (securityState.loaded &&
                          securityConfig.securityEnabled &&
                          _backgroundTime != null &&
                          !_isLocked) {
                        _isLocked = true;
                        _hasUnlockedThisSession = false;
                        _backgroundTime = null;
                      }

                      return Stack(
                        children: [
                          if (child != null) child,
                          if (securityConfig.securityEnabled && _isLocked)
                            SecurityLockScreen(
                              verifyPin: (pin) =>
                                  context.read<SecurityCubit>().verifyPin(pin),
                              bioEnabled: securityConfig.biometricEnabled,
                              onResult: (success) {
                                if (success) _onUnlockSuccess();
                              },
                            ),
                        ],
                      );
                    },
                    home: driveState is DriveError
                        ? ConnectDriveScreen(
                            error: driveState.message,
                            errorDetails: driveState.details,
                          )
                        : const _AppContainer(),
                  );
                },
              ),
            ),
          );
        },
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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignSystem.cleanWhite,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(0, 56),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusL),
        ),
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignSystem.radiusXL),
          ),
        ),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
        ),
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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignSystem.pureBlack,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size(0, 56),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusL),
        ),
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignSystem.radiusXL),
          ),
        ),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
        ),
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
