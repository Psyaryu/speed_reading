# Android Manual QA Checklist

Use this checklist for MVP release validation on Android. Record the app version, commit, device model, Android version, screen size, and tester before starting.

## Environment

- [ ] Android build completed successfully with `flutter build apk` or the selected release build command.
- [ ] App installs and launches on a phone-sized device or emulator.
- [ ] Device is set to airplane mode before first launch validation.
- [ ] Tester records any release blockers in this file or the release issue tracker.

## Offline Launch

- [ ] App opens in airplane mode without network error dialogs.
- [ ] Dashboard loads from local state or creates the local-only profile.
- [ ] Built-in official passages are available without network access.
- [ ] Imported passages and progress from a previous run appear after app restart.

## Layout and Text Overlap

- [ ] Dashboard, Library, Reader, Quiz, Results, Progress, and Settings fit on a phone viewport.
- [ ] Portrait layout has no clipped labels, overlapped controls, or unreadable quiz answers.
- [ ] Landscape layout remains usable for Reader, Quiz, and Results.
- [ ] Large Android font and display size settings do not break core flows.
- [ ] Tappable controls meet practical touch target size and spacing.

## Reader Flow

- [ ] Start a manual reading session from an official passage.
- [ ] Start a manual reading session from an imported pasted passage.
- [ ] Pause, resume, and finish actions behave predictably.
- [ ] Background and foreground the app during a session; behavior matches current session-reliability requirements.
- [ ] Reader preferences for font size, line height, column width, theme, and reduced motion persist after restart.

## Quiz and Results

- [ ] Completing a reading session opens the quiz flow.
- [ ] Answer choices are readable, selectable, and not obscured by the keyboard or system UI.
- [ ] Quiz submission produces a results screen with WPM and comprehension shown together.
- [ ] Results show ERS or level context where available.
- [ ] Attempts below 70% comprehension do not appear as qualified progress.

## Reset, Export, and Share

- [ ] Export preview produces valid-looking JSON and CSV content.
- [ ] Reset progress requires confirmation.
- [ ] Reset clears progress history without deleting official bundled passages.
- [ ] Imported passage handling matches current product behavior after reset.
- [ ] Progress sharing opens the Android share sheet.
- [ ] Shared summary excludes private imported passage text.

## Local Storage

- [ ] Force close and reopen the app; profile settings persist.
- [ ] Force close and reopen the app; imported pasted passages persist.
- [ ] Force close and reopen the app; completed reading sessions and quiz results persist.
- [ ] Local-only use does not prompt for account, cloud sync, or network permission.

## Reduced Motion and Theme

- [ ] Reduced motion setting remains enabled after restart.
- [ ] Reader and navigation do not rely on motion to communicate required state.
- [ ] System, light, and dark theme settings apply correctly.
- [ ] Android dark mode and high contrast or increased contrast settings leave primary text and controls legible.

## Android Readiness

- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] Android release or debug build command passes on the release machine.
- [ ] App installs cleanly on a representative Android device or emulator.
- [ ] Release notes include any unresolved Android blockers.
