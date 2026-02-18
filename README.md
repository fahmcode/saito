# saito

Offline-first workout tracker with optional Google Drive backup.

## Sync
- Connect Google Drive to store a single `workout_state.json` file in the appData folder.
- Data synced: workout progress only (streaks, days, volumes, baseline reps).
- Preferences and security settings stay on-device.
- You can choose offline-only mode; reconnect later to sync.

## Platform setup
- **Android:** create an OAuth client in Google Cloud Console with your app SHA-1; `google_sign_in` handles runtime auth.
- **iOS:** add the `REVERSED_CLIENT_ID` URL scheme from the generated `GoogleService-Info.plist` and include Drive scope.

Run `flutter pub get` after editing dependencies.
