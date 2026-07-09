# iOS Manual QA Checklist

Use this checklist for MVP release validation on iOS. Record the app version, commit, device model, iOS version, screen size, Xcode version, and tester before starting.

## Environment

- [ ] iOS build configuration is present in the repo.
- [ ] App builds from macOS with Xcode using the selected Flutter iOS build command.
- [ ] App installs and launches on an iPhone-sized simulator or device.
- [ ] Device or simulator has network disabled before first launch validation.
- [ ] Tester records any release blockers in this file or the release issue tracker.

## Offline Launch

- [ ] App opens while offline without network error dialogs.
- [ ] Dashboard loads from local state or creates the local-only profile.
- [ ] Built-in official passages are available without network access.
- [ ] Imported passages and progress from a previous run appear after app restart.

## Layout and Text Overlap

- [ ] Dashboard, Library, Reader, Quiz, Results, Progress, and Settings fit on an iPhone viewport.
- [ ] Portrait layout has no clipped labels, overlapped controls, or unreadable quiz answers.
- [ ] Landscape layout remains usable for Reader, Quiz, and Results.
- [ ] Large Dynamic Type settings do not break core flows.
- [ ] Controls remain reachable and are not hidden by safe areas, keyboard, or home indicator.

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
- [ ] Progress sharing opens the iOS share sheet.
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
- [ ] iOS dark mode and Increase Contrast settings leave primary text and controls legible.

## iOS Readiness

- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] iOS build command passes on macOS with Xcode.
- [ ] App installs cleanly on a representative iOS simulator or device.
- [ ] Release notes include any unresolved iOS blockers.
