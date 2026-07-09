# Windows Manual QA Checklist

Use this checklist for MVP release validation on Windows desktop. Record the app version, commit, device, OS version, and tester before starting.

## Environment

- [ ] Flutter Windows build completed successfully with `flutter build windows`.
- [ ] App launches from `build/windows/x64/runner/Release/speed_reading.exe`.
- [ ] Test machine has network disabled before first launch validation.
- [ ] Tester records any release blockers in this file or the release issue tracker.

## Offline Launch

- [ ] App opens while offline without network error dialogs.
- [ ] Dashboard loads from local state or creates the local-only profile.
- [ ] Built-in official passages are available without network access.
- [ ] Imported passages and progress from a previous run appear after restart.

## Layout and Text Overlap

- [ ] Dashboard, Library, Reader, Quiz, Results, Progress, and Settings fit at 1280x720.
- [ ] Same screens fit at 1920x1080.
- [ ] Large text settings do not cause clipped labels, overlapped buttons, or hidden quiz answers.
- [ ] Reader column width setting keeps passage text readable without horizontal scrolling.
- [ ] Keyboard focus indicators are visible on navigation and primary actions.

## Reader Flow

- [ ] Start a manual reading session from an official passage.
- [ ] Start a manual reading session from an imported pasted passage.
- [ ] Pause, resume, and finish actions behave predictably.
- [ ] Reading WPM and elapsed time are plausible for the passage length.
- [ ] Reader preferences for font size, line height, column width, theme, and reduced motion persist after restart.

## Quiz and Results

- [ ] Completing a reading session opens the quiz flow.
- [ ] Every answer choice is readable and selectable with mouse and keyboard.
- [ ] Quiz submission produces a results screen with WPM and comprehension shown together.
- [ ] Results show ERS or level context where available.
- [ ] Attempts below 70% comprehension do not appear as qualified progress.

## Reset, Export, and Share

- [ ] Export preview produces valid-looking JSON and CSV content.
- [ ] Reset progress requires confirmation.
- [ ] Reset clears progress history without deleting official bundled passages.
- [ ] Imported passage handling matches current product behavior after reset.
- [ ] Progress sharing opens the Windows share target when available.
- [ ] Shared summary excludes private imported passage text.

## Local Storage

- [ ] Close and reopen the app; profile settings persist.
- [ ] Close and reopen the app; imported pasted passages persist.
- [ ] Close and reopen the app; completed reading sessions and quiz results persist.
- [ ] Local-only use does not prompt for account, cloud sync, or network permission.

## Reduced Motion and Theme

- [ ] Reduced motion setting remains enabled after restart.
- [ ] Reader and navigation do not rely on motion to communicate required state.
- [ ] System, light, and dark theme settings apply correctly.
- [ ] High contrast Windows mode leaves primary text and controls legible.

## Windows Readiness

- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] `flutter build windows` passes.
- [ ] App can be launched from the generated release folder.
- [ ] Release notes include any unresolved Windows blockers.
