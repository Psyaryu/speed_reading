# Speed Reading Trainer

Flutter application for structured speed-reading practice with comprehension-first progression toward 800 WPM.

## Requirements

- Flutter stable SDK
- Dart SDK included with Flutter
- Windows desktop tooling for Windows builds
- Android Studio or Android command-line tooling for Android builds
- Xcode on macOS for iOS builds

## Setup

```powershell
flutter pub get
```

## Run

```powershell
flutter run -d windows
flutter run -d android
```

iOS builds require macOS with Xcode:

```bash
flutter run -d ios
```

## Verify

```powershell
flutter analyze
flutter test
```

Unit, widget, and integration-style flow coverage currently lives under `test/`.
Widget and screen tests cover app flows until a platform-driven
`integration_test/` harness is needed for release validation.

## Project Docs

- [PRD.md](./PRD.md)
- [TASKS.md](./TASKS.md)
- [AGENTS.md](./AGENTS.md)
