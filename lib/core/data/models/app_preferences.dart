import 'package:hive/hive.dart';

part 'app_preferences.g.dart';

@HiveType(typeId: 2)
class AppPreferences extends HiveObject {
  @HiveField(0)
  bool audioEnabled;

  @HiveField(1)
  bool hapticsEnabled;

  @HiveField(2)
  String themeMode;

  @HiveField(3)
  bool onboardingComplete;

  AppPreferences({
    this.audioEnabled = true,
    this.hapticsEnabled = true,
    this.themeMode = 'system',
    this.onboardingComplete = false,
  });

  AppPreferences copyWith({
    bool? audioEnabled,
    bool? hapticsEnabled,
    String? themeMode,
    bool? onboardingComplete,
  }) {
    return AppPreferences(
      audioEnabled: audioEnabled ?? this.audioEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      themeMode: themeMode ?? this.themeMode,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
