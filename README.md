# Main Ledger

Flutter app for managing driver ledgers, parcel attachment, settlement, local Drift storage, and Firebase sync.

## Requirements

- Flutter SDK
- Firebase project access
- Android `google-services.json`
- Generated `lib/core/firebase/firebase_options.dart`

## Firebase Setup

This public repository does not include Firebase app config files.

Add these files locally before running the app:

- `android/app/google-services.json`
- `lib/core/firebase/firebase_options.dart`

You can generate `firebase_options.dart` with FlutterFire CLI, or restore it from your private project setup.

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter analyze
flutter test
```
