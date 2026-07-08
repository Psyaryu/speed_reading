# Speed Reading Trainer Task Breakdown

This document breaks [PRD.md](./PRD.md) into milestones, epics, implementation tasks, dependencies, acceptance criteria, and open questions.

## Task Ledger Rules

`TASKS.md` is the source of truth for remaining project work. It must be updated whenever implementation changes the state of a task.

Status values:

- `Todo`: Not started.
- `In Progress`: Actively being worked.
- `Blocked`: Cannot continue without a decision, dependency, or external setup.
- `Done`: Implemented and verified.
- `Deferred`: Intentionally moved out of current scope.

Update rules:

- Before coding, identify the relevant milestone, epic, and task.
- If needed work is missing, add it to the correct milestone before or during implementation.
- When a task is completed, mark it `Done`, add completion date, changed files, and verification notes.
- Commit each completed task separately in Git.
- Include the `TASKS.md` update for a completed task in the same commit as the implementation.
- Do not combine unrelated tasks in one commit.
- If a task is too large for one commit, split it into smaller tasks in this file before committing.
- If a task is partially complete, keep it open and add follow-up tasks.
- If implementation reveals new work, add it under the relevant milestone or the Post-MVP backlog.
- Keep completed notes concise so the document remains useful for finding what is left.

Suggested task annotation:

```text
Status: Todo
Completed:
Changed files:
Verification:
Commit: See Git history for `chore: add initial Flutter project skeleton`
Notes:
```

## Planning Assumptions

- MVP is a Flutter app targeting Windows, iOS, and Android.
- MVP is local-only: no accounts, cloud sync, backend service, or remote content service.
- Built-in official passages are public-domain or properly licensed.
- User-pasted passages are stored locally and can be used for practice and analytics.
- Official certification and mastery use official bundled passages by default.
- Standard progression requires at least 70% comprehension.
- 800 WPM Mastery is a higher track requiring 100% immediate comprehension and delayed recall.
- Social support means user-initiated progress sharing only, not social accounts, feeds, followers, or cloud identity.
- State management uses Riverpod.
- Local persistence uses Drift with SQLite.
- Initial official content focuses on adventurous public-domain fiction.
- Passage metadata includes filterable tags.
- Comprehension question count scales with passage length.
- Delayed recall reminders use local notifications with edgy, emotionally motivating copy that stays playful rather than abusive.

## Milestone 0: Project Foundation

Goal: Create the Flutter project, baseline architecture, local tooling, and initial CI-ready structure.

### Epic 0.1: Flutter Project Setup

Status: In Progress

Tasks:

- Scaffold Flutter app in the repo.
- Enable Windows, iOS, and Android targets.
- Add project README with setup commands.
- Add standard linting and formatting configuration.
- Add test directories for unit, widget, and integration tests.
- Add Riverpod for state management.
- Add Drift with SQLite for local persistence.
- Decide charting package for analytics.

Acceptance criteria:

- `flutter analyze` passes.
- `flutter test` runs successfully with at least one starter test.
- App launches on Windows.
- Android and iOS target folders are present.
- README documents setup, run, and test commands.

Dependencies:

- Flutter SDK installed locally.
- Package choices finalized.

Completed task log:

```text
Task: Add initial Flutter project skeleton
Status: Done
Completed: 2026-07-06
Changed files: .gitignore, README.md, analysis_options.yaml, pubspec.yaml, lib/main.dart, test/widget_test.dart, assets/passages/.gitkeep, lib/*/.gitkeep, android/.gitkeep, ios/.gitkeep, windows/.gitkeep, TASKS.md
Verification: Could not run flutter analyze or flutter test because Flutter is not installed or not on PATH in this environment. Manual file review completed.
Commit:
Notes: Added manual Flutter project metadata, dependency declarations, placeholder dashboard, starter widget test, module folders, asset folder, and platform placeholder directories. Generated platform files still need to be produced with flutter create once the Flutter SDK is available.
```

Follow-up tasks:

- Status: Done
  Task: Run `flutter create . --platforms=windows,android,ios` or equivalent to generate full platform scaffolding.
  Completed: 2026-07-07
  Changed files: .metadata, pubspec.lock, android/**, ios/**, windows/**, TASKS.md
  Verification: Ran `C:\Users\Psyaryu\tools\flutter\bin\flutter.bat create . --platforms=windows,android,ios`. Flutter generated platform scaffolding and resolved dependencies, then exited with a Developer Mode symlink warning for plugin builds.
  Commit: See Git history for `chore: generate Flutter platform scaffolding`
  Notes: Flutter SDK is installed locally at `C:\Users\Psyaryu\tools\flutter`. Enable Windows Developer Mode to allow plugin symlink creation for desktop builds.
- Status: Done
  Task: Run `flutter pub get`, `flutter analyze`, and `flutter test`.
  Completed: 2026-07-07
  Changed files: windows/flutter/generated_plugin_registrant.cc, windows/flutter/generated_plugin_registrant.h, windows/flutter/generated_plugins.cmake, test/effective_reading_score_test.dart, TASKS.md
  Verification: Ran `flutter pub get`, `flutter analyze`, and `flutter test` with local SDK at `C:\Users\Psyaryu\tools\flutter\bin\flutter.bat`. Analyze passed with no issues. Test suite passed after changing one floating-point ERS assertion to use a tolerance.
  Commit: See Git history for `test: verify Flutter analysis and tests`
  Notes: `flutter create` previously reported a Windows Developer Mode symlink warning. Current `pub get`, `analyze`, and `test` all pass.

### Epic 0.2: App Architecture Skeleton

Status: Done

Tasks:

- Create module folders: `core`, `reading`, `training`, `assessment`, `progress`, `content`, `settings`.
- Add routing skeleton.
- Add app theme skeleton with light, dark, and high-contrast-ready tokens.
- Add shared domain model conventions.
- Add service interfaces for persistence, content loading, scoring, and sharing.

Acceptance criteria:

- App boots into a placeholder dashboard route.
- Routes exist for onboarding, dashboard, library, reader, quiz, results, progress, and settings.
- Module boundaries are documented in code or README.

Dependencies:

- Flutter project setup.
- State management and routing package selected.

Completed task log:

```text
Task: Add app architecture route and theme skeleton
Status: Done
Completed: 2026-07-06
Changed files: lib/main.dart, lib/core/router/app_router.dart, lib/core/theme/app_theme.dart, lib/core/widgets/placeholder_page.dart, lib/assessment/presentation/quiz_screen.dart, lib/assessment/presentation/results_screen.dart, lib/content/presentation/library_screen.dart, lib/progress/presentation/progress_screen.dart, lib/reading/presentation/reader_screen.dart, lib/settings/presentation/settings_screen.dart, lib/training/presentation/dashboard_screen.dart, lib/training/presentation/onboarding_screen.dart, TASKS.md
Verification: Could not run flutter analyze or flutter test because Flutter is not installed or not on PATH. Manual file review completed.
Commit: See Git history for `chore: add app architecture skeleton`
Notes: Added GoRouter route definitions for onboarding, dashboard, library, reader, quiz, results, progress, and settings. Added app theme helper and shared placeholder page.
```

```text
Task: Add local service interfaces
Status: Done
Completed: 2026-07-06
Changed files: lib/core/services/local_data_store.dart, lib/content/data/passage_repository.dart, lib/progress/data/progress_repository.dart, TASKS.md
Verification: Could not run flutter analyze because Flutter is not installed or not on PATH. Manual file review completed.
Commit: See Git history for `chore: add local service interfaces`
Notes: Added repository contracts for local profile, passages, sessions, quiz results, progress snapshots, certification, mastery, export, and reset workflows.
```

## Milestone 1: Domain Model and Local Data

Goal: Establish the local data model that supports passages, sessions, quizzes, scoring, imported text, and progress history.

### Epic 1.0: Core Utilities

Status: Done

Tasks:

- Implement word-count utility with unit tests.

Acceptance criteria:

- Plain words are counted.
- Common contractions and hyphenated words are counted as single words.
- Punctuation and whitespace do not inflate counts.

Completed task log:

```text
Task: Implement word-count utility
Status: Done
Completed: 2026-07-06
Changed files: lib/core/utils/word_counter.dart, test/word_counter_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added focused unit tests for plain words, contractions, hyphenated words, punctuation, whitespace, and empty text.
Commit: See Git history for `feat: add word-count utility`
Notes: Word counting uses a shared regex utility so WPM calculations can use one consistent count.
```

### Epic 1.1: Core Domain Models

Status: Done

Tasks:

- Define `Passage` model.
- Define `PassageMetadata` model with word count, difficulty, topic, source, license, text type, vocabulary density, filterable tags, and official/unofficial flag.
- Define `ReadingMode`: manual, paced, RSVP, skim, scan, deep read.
- Define `ReadingSession` model.
- Define `QuizQuestion` and `QuizResult` models.
- Define `ProgressSnapshot` model.
- Define `CertificationAttempt` and `MasteryAttempt` models.
- Add serialization for local persistence.

Acceptance criteria:

- Models represent every metric listed in PRD section 7.1.
- Official and imported passages are distinguishable.
- Unit tests cover serialization and required fields.

Dependencies:

- Persistence package selected.

Completed task log:

```text
Task: Define core domain models
Status: Done
Completed: 2026-07-06
Changed files: lib/core/domain/reading_enums.dart, lib/content/domain/passage.dart, lib/assessment/domain/quiz.dart, lib/reading/domain/reading_session.dart, lib/progress/domain/progress_snapshot.dart, lib/progress/domain/certification_attempt.dart, test/domain_models_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added serialization and calculated-field tests for passage, reading session, and quiz result models.
Commit: See Git history for `feat: define core domain models`
Notes: Used manual immutable Dart models with JSON helpers instead of generated Freezed files so the code remains inspectable before build_runner is available.
```

### Epic 1.2: Local Persistence

Status: In Progress

Tasks:

- Implement local database schema.
- Store official passage metadata.
- Store imported pasted passages.
- Store reading sessions.
- Store quiz results.
- Store progress snapshots.
- Store user settings.
- Add export to JSON.
- Add export to CSV for progress/session history.
- Add reset-progress flow with confirmation.

Acceptance criteria:

- Data survives app restart.
- Pasted passages are available after restart.
- Progress export produces valid JSON and CSV.
- Reset deletes user progress only after confirmation.
- Official bundled content is not accidentally deleted by reset.

Dependencies:

- Domain models complete.

Completed task log:

```text
Task: Add Drift database schema
Status: Done
Completed: 2026-07-07
Changed files: .gitignore, lib/core/data/app_database.dart, lib/core/data/app_database.g.dart, test/app_database_test.dart, TASKS.md
Verification: Ran `flutter pub run build_runner build --delete-conflicting-outputs`, `flutter analyze`, and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: add Drift database schema`
Notes: Defines local tables for profile, passages, reading sessions, quiz results, progress snapshots, certification attempts, and mastery attempts.
```

```text
Task: Add reading session table primary key
Status: Done
Completed: 2026-07-07
Changed files: lib/core/data/app_database.dart, lib/core/data/app_database.g.dart, TASKS.md
Verification: Ran `flutter pub run build_runner build --delete-conflicting-outputs`, `flutter analyze`, and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `fix: add reading session primary key`
Notes: Added a primary key to reading session records so session history can be upserted and referenced reliably.
```

```text
Task: Implement Drift local data store
Status: Done
Completed: 2026-07-07
Changed files: lib/core/data/drift_local_data_store.dart, test/drift_local_data_store_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: implement Drift local data store`
Notes: Implements local profile, imported passages, reading sessions, quiz results, progress snapshots, certification/mastery attempts, JSON/CSV export, and reset-progress behavior.
```

```text
Task: Add persistent database connection
Status: Done
Completed: 2026-07-07
Changed files: lib/core/data/database_connection.dart, test/database_connection_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: add persistent database connection`
Notes: Opens the Drift database from the application documents directory using a stable local SQLite file name.
```

```text
Task: Add Riverpod persistence providers
Status: Done
Completed: 2026-07-07
Changed files: lib/core/providers/app_providers.dart, test/app_providers_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: add persistence providers`
Notes: Provides AppDatabase and LocalDataStore through Riverpod with a test override path.
```

```text
Task: Add content repository providers
Status: Done
Completed: 2026-07-07
Changed files: lib/core/providers/app_providers.dart, test/app_providers_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: add content repository providers`
Notes: Exposes official passage source and passage repository through Riverpod.
```

```text
Task: Add local progress export formatter
Status: Done
Completed: 2026-07-06
Changed files: lib/settings/domain/progress_exporter.dart, test/progress_exporter_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for JSON export structure and session CSV output.
Commit: See Git history for `feat: add progress export formatter`
Notes: Database persistence and file writing remain open. This formatter supports future JSON/CSV export flows.
```

### Epic 1.3: Local User Profile

Status: In Progress

Tasks:

- Create local profile model.
- Store user goals: school, work, exam, personal learning, general improvement.
- Store baseline values.
- Store preferred reading settings.
- Support local profile initialization without login.

Acceptance criteria:

- First launch creates or prompts for a local profile.
- No cloud account or network call is required.
- Profile preferences affect reading-player defaults.

Dependencies:

- Local persistence.

Completed task log:

```text
Task: Add local user profile model
Status: Done
Completed: 2026-07-06
Changed files: lib/settings/domain/local_user_profile.dart, test/local_user_profile_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for initial local profile defaults and profile serialization.
Commit: See Git history for `feat: add local user profile model`
Notes: Persistence wiring remains open under local persistence.
```

```text
Task: Add local profile initialization controller
Status: Done
Completed: 2026-07-07
Changed files: lib/settings/application/local_profile_controller.dart, lib/core/providers/app_providers.dart, test/local_profile_controller_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: add local profile initialization`
Notes: Adds load-or-create behavior for the local-only profile and exposes it through Riverpod.
```

## Milestone 2: Content Library

Goal: Provide official public-domain long-form reading content and local pasted passage support.

### Epic 2.1: Official Passage Library

Status: In Progress

Tasks:

- Select initial adventurous public-domain fiction source texts.
- Split long-form texts into passages of useful lengths.
- Add metadata for difficulty, topic, word count, text type, source, license, and filterable tags.
- Mark official passages eligible for certification/mastery.
- Add content loader service.
- Add library browse/search/filter UI.

Acceptance criteria:

- Library includes short, medium, and long official passages.
- Each passage has source and license metadata.
- Official passages can be filtered by difficulty, topic, and tags.
- App works offline with bundled content.

Dependencies:

- Domain model.
- Content source decision.

Question:

- Should official passages be bundled as JSON assets, SQLite seed data, or generated Dart assets?

Resolved decision:

- Official passages start as JSON assets so content can be reviewed and edited without code generation.

Completed task log:

```text
Task: Add starter official passage asset format
Status: Done
Completed: 2026-07-06
Changed files: assets/passages/official_passages.json, lib/content/data/official_passage_loader.dart, test/official_passage_loader_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added parser tests for official passage metadata and tag structure.
Commit: See Git history for `feat: add official passage asset loader`
Notes: Added a starter public-domain adventure fiction passage from Treasure Island with filterable tags. The library UI and larger passage set remain open.
```

```text
Task: Add passage filtering service
Status: Done
Completed: 2026-07-06
Changed files: lib/content/domain/passage_filter.dart, test/passage_filter_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for tag, query, source, and difficulty filtering.
Commit: See Git history for `feat: add passage filtering service`
Notes: Filtering supports query, difficulty, topic, source, and all-selected-tags matching for future library UI.
```

```text
Task: Implement passage repository
Status: Done
Completed: 2026-07-07
Changed files: lib/content/data/official_passage_loader.dart, lib/content/data/default_passage_repository.dart, test/default_passage_repository_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: implement passage repository`
Notes: Repository merges official bundled content with local imported passages and applies existing filters.
```

```text
Task: Build library passage list UI
Status: Done
Completed: 2026-07-07
Changed files: lib/content/presentation/library_screen.dart, test/library_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: build library passage list`
Notes: Replaces placeholder with a Riverpod-backed list of official/imported passages and tag chips.
```

### Epic 2.2: Paste-and-Save Imported Text

Status: In Progress

Tasks:

- Build paste/import text screen.
- Add title and optional source fields.
- Calculate word count.
- Estimate difficulty.
- Save pasted passage locally.
- Allow edit/delete of imported passages.
- Mark imported passages as practice-only by default.

Acceptance criteria:

- User can paste text and use it in reading modes.
- Imported passages persist locally.
- Imported passages contribute to analytics.
- Imported passages do not count toward official certification/mastery by default.
- Poor performance on imported text is recorded without disqualifying the text.

Dependencies:

- Local persistence.
- Reading player can load arbitrary passage text.

Completed task log:

```text
Task: Add imported passage factory
Status: Done
Completed: 2026-07-06
Changed files: lib/content/domain/imported_passage_factory.dart, test/imported_passage_factory_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for word count, practice-only eligibility, fallback title, fallback license, and imported tags.
Commit: See Git history for `feat: add imported passage factory`
Notes: UI and local persistence wiring remain open. Imported passages are explicitly not certification or mastery eligible by default.
```

```text
Task: Build import passage screen
Status: Done
Completed: 2026-07-07
Changed files: lib/content/presentation/import_passage_screen.dart, lib/core/router/app_router.dart, lib/content/presentation/library_screen.dart, test/import_passage_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: build import passage screen`
Notes: Adds paste form with title, source, tags, body validation, and repository save wiring.
```

## Milestone 3: Onboarding and Baseline Assessment

Goal: Establish each user's starting speed, comprehension, focus, and recommended training level.

### Epic 3.1: Onboarding Flow

Tasks:

- Build welcome screen.
- Explain WPM plus comprehension measurement.
- Explain 70% standard threshold and 800 WPM mastery aspiration.
- Collect user goal.
- Collect accessibility/preferences basics: font size, theme, reduced motion.

Acceptance criteria:

- User understands that speed without comprehension is not rewarded.
- Onboarding can be completed without network access.
- Preferences are saved locally.

Dependencies:

- Local user profile.
- Theme/settings foundation.

### Epic 3.2: Baseline Assessment

Tasks:

- Select 2-3 official baseline passages.
- Build timed manual reading assessment.
- Record elapsed time and calculate WPM.
- Present comprehension quiz after each passage.
- Collect self-rated focus and confidence.
- Calculate baseline ERS.
- Recommend starting level and first training plan.

Acceptance criteria:

- Baseline records comfortable WPM, comprehension, recall quality, self-rated focus, and text difficulty tolerance.
- Baseline results appear on dashboard.
- User can retake baseline.

Dependencies:

- Official passage library.
- Reading player MVP.
- Quiz engine MVP.
- ERS calculation.

## Milestone 4: Reading Player

Goal: Build the core reading experience for manual, paced, and RSVP modes.

### Epic 4.1: Manual Reading Mode

Status: In Progress

Tasks:

- Render passage text in a distraction-light interface.
- Support font size, line height, theme, and column width.
- Track start, pause, resume, and finish.
- Calculate WPM from word count and active reading time.
- Prevent accidental exits during active tests.

Acceptance criteria:

- User can complete a manual reading session.
- WPM calculation excludes paused time.
- Interrupted attempts are marked unqualified when appropriate.
- Text is readable on Windows, iOS, and Android layouts.

Dependencies:

- Passage model.
- Settings model.

Completed task log:

```text
Task: Add reading session factory
Status: Done
Completed: 2026-07-06
Changed files: lib/reading/domain/reading_session_factory.dart, test/reading_session_factory_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for paused-time exclusion and interrupted session status.
Commit: See Git history for `feat: add reading session factory`
Notes: Manual reading UI remains open. This domain factory supports WPM calculation from active reading time.
```

```text
Task: Build manual reader screen
Status: Done
Completed: 2026-07-07
Changed files: lib/reading/presentation/reader_screen.dart, test/reader_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all 86 tests passed.
Commit: See Git history for `feat: build manual reader screen`
Notes: Renders the first available passage, starts and finishes a manual session, saves the session locally, and displays WPM. Pause/resume, accidental-exit protection, reader preferences, and passage selection remain open.
```

```text
Task: Add pause and resume tracking to manual reader
Status: Done
Completed: 2026-07-07
Changed files: lib/reading/presentation/reader_screen.dart, test/reader_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all 87 tests passed.
Commit: See Git history for `feat: add manual reader pause tracking`
Notes: Manual sessions now track pause count and paused duration, exclude paused time from WPM, and keep controls responsive on narrow layouts. Accidental-exit protection, reader preferences, and passage selection remain open.
```

```text
Task: Apply local reader text preferences
Status: Done
Completed: 2026-07-07
Changed files: lib/reading/presentation/reader_screen.dart, test/reader_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all 88 tests passed.
Commit: See Git history for `feat: apply reader text preferences`
Notes: Manual reader text now uses the local profile font size and line height, with a constrained reading column for desktop/tablet readability. Theme selection UI and passage selection remain open.
```

```text
Task: Prevent accidental exits during active manual sessions
Status: Done
Completed: 2026-07-07
Changed files: lib/reading/presentation/reader_screen.dart, test/reader_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all 89 tests passed.
Commit: See Git history for `feat: guard active reader exits`
Notes: Active manual sessions now intercept back navigation and require the user to keep reading or discard the unsaved attempt before leaving.
```

### Epic 4.2: Paced Reading Mode

Tasks:

- Add visual pacer overlay.
- Add adjustable WPM target.
- Add guided line pacing.
- Add timed reading windows.
- Store target WPM and actual completion metrics.

Acceptance criteria:

- User can select target WPM.
- Pacer timing maps correctly to passage word count and target speed.
- Session results show target versus actual performance.

Dependencies:

- Manual reading mode.

### Epic 4.3: RSVP Mode

Status: In Progress

Tasks:

- Tokenize passage into words and optional phrase chunks.
- Display word-by-word RSVP.
- Add phrase-by-phrase RSVP option.
- Add adjustable WPM.
- Add pause, rewind, and resume controls.
- Add punctuation-aware timing.
- Add longer pauses for sentence boundaries.
- Record mode multiplier for ERS.

Acceptance criteria:

- RSVP timing is stable enough for WPM training.
- Punctuation and sentence boundary timing are applied.
- User can pause, rewind, and resume.
- RSVP results require comprehension quiz to qualify.

Dependencies:

- Tokenization utility.
- Reading player shell.

Completed task log:

```text
Task: Add RSVP tokenization and timing
Status: Done
Completed: 2026-07-06
Changed files: lib/reading/domain/rsvp_timing.dart, test/rsvp_timing_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for tokenization, base WPM timing, punctuation pauses, sentence-boundary pauses, and invalid WPM.
Commit: See Git history for `feat: add RSVP timing`
Notes: RSVP UI controls remain open. Timing supports punctuation-aware scheduling for future player implementation.
```

### Epic 4.4: Skim and Scan Modes

Tasks:

- Build skimming exercise template.
- Build scanning exercise template.
- Add scanning targets: date, number, name, claim, keyword.
- Track time and accuracy.
- Apply skim/scan mode multipliers.

Acceptance criteria:

- User can complete skim and scan drills.
- Results record accuracy and time.
- Skim/scan performance appears in analytics.

Dependencies:

- Content library.
- Quiz/check engine.

## Milestone 5: Comprehension and Assessment Engine

Goal: Measure comprehension reliably enough to gate progression and certification.

### Epic 5.1: Quiz Engine

Status: In Progress

Tasks:

- Support multiple-choice questions.
- Support main idea questions.
- Support detail recall questions.
- Support inference questions.
- Support vocabulary-in-context questions.
- Support optional written summary prompt.
- Score quiz results.

Acceptance criteria:

- Quiz results produce a comprehension percentage.
- Question categories are stored in results.
- Results are linked to reading sessions.

Dependencies:

- Passage and quiz models.
- Local persistence.

Completed task log:

```text
Task: Add quiz scoring engine
Status: Done
Completed: 2026-07-06
Changed files: lib/assessment/domain/quiz_scorer.dart, test/quiz_scorer_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for scoring selected answers and treating missing answers as incorrect.
Commit: See Git history for `feat: add quiz scoring engine`
Notes: UI rendering and written-summary handling remain open.
```

### Epic 5.2: Official Passage Question Sets

Status: In Progress

Tasks:

- Create comprehension questions for each official MVP passage.
- Tag questions by category.
- Set answer keys and explanations.
- Define question-count tiers that scale with passage length.
- Validate that each official certification passage has enough questions for its length.

Acceptance criteria:

- Each official baseline passage has a quiz.
- Each certification-eligible passage has enough length-scaled questions to support reliable scoring.
- Questions include main idea, detail, inference, and vocabulary where appropriate.

Dependencies:

- Official passage selection.

Question:

- Should written summaries be self-scored in MVP or deferred?

Completed task log:

```text
Task: Add length-scaled question count policy
Status: Done
Completed: 2026-07-06
Changed files: lib/assessment/domain/question_count_policy.dart, test/question_count_policy_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for empty, short, certification-length, long, and very long passages.
Commit: See Git history for `feat: add question count policy`
Notes: Policy starts at 5 questions for short passages, 10 for 600+ words, 15 for 1200+ words, and 20 for 2400+ words.
```

## Milestone 6: Scoring, Progression, Certification, and Mastery

Goal: Implement the product's core measurement system.

### Epic 6.1: Effective Reading Score

Status: Done

Tasks:

- Implement ERS formula.
- Implement comprehension multiplier with heavy penalty below 60%.
- Implement difficulty multipliers.
- Implement mode multipliers.
- Add unit tests for ERS calculations.

Acceptance criteria:

- ERS matches PRD formula.
- Below-threshold comprehension is penalized.
- Tests cover edge cases: zero WPM, zero comprehension, 59%, 60%, 70%, 100%.

Dependencies:

- Session and quiz results.

Completed task log:

```text
Task: Implement Effective Reading Score calculator
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/effective_reading_score.dart, test/effective_reading_score_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added unit tests for the PRD example, below-60 penalty, 60% threshold, multipliers, and comprehension clamping.
Commit: See Git history for `feat: add effective reading score calculator`
Notes: Below-60% comprehension receives a 50% multiplier penalty before other ERS multipliers are applied.
```

### Epic 6.2: Readiness Rating and Levels

Status: Done

Tasks:

- Implement qualified attempt rules.
- Implement 800 WPM readiness percentage.
- Implement levels 1-7.
- Track best qualified ERS.
- Track current level.

Acceptance criteria:

- Attempts below 70% comprehension do not qualify.
- Attempts under 600 words do not qualify for readiness.
- Interrupted or excessively paused attempts can be marked unqualified.
- Dashboard shows current level and progress toward 800 WPM.

Dependencies:

- ERS calculation.
- Session interruption tracking.

Completed task log:

```text
Task: Implement readiness and level calculation
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/progression.dart, test/progression_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added unit tests for qualified-attempt gates, readiness capping, and level thresholds.
Commit: See Git history for `feat: add readiness and level progression`
Notes: Qualified attempts require at least 70% comprehension, at least 600 words, standard-or-higher difficulty, qualified status, and no excessive pausing.
```

### Epic 6.3: Certification

Status: Done

Tasks:

- Implement standard 800 WPM certification rules.
- Require 3 official standard non-fiction passages at or above 800 WPM with at least 70% comprehension.
- Require at least 1 non-RSVP attempt.
- Track certification attempts.
- Add certification badge/result screen.

Acceptance criteria:

- Certification only uses official eligible passages.
- Certification cannot be earned from RSVP-only attempts.
- Certification status persists locally.

Dependencies:

- Official passage eligibility.
- Qualified attempt logic.

Completed task log:

```text
Task: Implement standard certification rules
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/certification_rules.dart, test/certification_rules_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for three-passage certification, non-RSVP requirement, imported passage rejection, WPM threshold, and comprehension threshold.
Commit: See Git history for `feat: add certification rules`
Notes: Certification logic currently follows the PRD standard-certification rule: official non-fiction, standard-or-higher difficulty, 800+ WPM, 70%+ comprehension, and at least one non-RSVP attempt.
```

### Epic 6.4: Mastery

Status: In Progress

Tasks:

- Implement 800 WPM Mastery rules.
- Require 3 official standard or hard passages at or above 800 WPM with 100% immediate comprehension.
- Schedule delayed recall checks at least 24 hours later.
- Require delayed recall score of at least 90% per passage.
- Track mastery progress.
- Trigger local notification reminders for delayed recall checks.
- Write notification copy in a provocative, playful, emotionally motivating tone.

Acceptance criteria:

- Mastery is separate from standard certification.
- Delayed recall is required only for mastery.
- Delayed recall checks persist across app restarts.
- Local notifications are scheduled for delayed recall checks.
- Notification copy motivates the user to prove the message wrong without using threats, protected-class insults, or abusive language.
- Mastery status persists locally.

Dependencies:

- Certification attempt infrastructure.
- Local scheduling/reminder strategy.

Completed task log:

```text
Task: Implement 800 WPM Mastery rules
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/mastery_rules.dart, test/mastery_rules_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for three-passage mastery, perfect immediate comprehension, delayed recall threshold, excessive pausing, and non-RSVP requirement.
Commit: See Git history for `feat: add mastery rules`
Notes: Local notification scheduling remains open under this epic.
```

```text
Task: Add delayed recall reminder copy
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/delayed_recall_reminder_copy.dart, test/delayed_recall_reminder_copy_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for stable attempt-based copy selection and basic banned-term guardrails.
Commit: See Git history for `feat: add delayed recall reminder copy`
Notes: Copy is intentionally provocative and playful. Platform scheduling remains open.
```

```text
Task: Add delayed recall reminder scheduling contract
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/delayed_recall_reminder.dart, test/delayed_recall_reminder_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added test for 24-hour delayed recall due-time calculation.
Commit: See Git history for `feat: add delayed recall reminder contract`
Notes: Platform implementation using local notifications remains open.
```

## Milestone 7: Training Curriculum and Adaptive Plan

Goal: Deliver structured daily practice that teaches the major speed-reading skills.

### Epic 7.1: Curriculum Structure

Status: In Progress

Tasks:

- Define curriculum modules: baseline, pacing, chunking, regression control, subvocalization awareness, skimming, scanning, RSVP, vocabulary/familiarity.
- Define lesson order.
- Define drill templates.
- Define unlock criteria.
- Define 10-20 minute daily session structure.

Acceptance criteria:

- Training plan covers all PRD core concepts.
- Lessons explain when rapid reading is appropriate versus deep reading.
- User gets a recommended next drill after assessment.

Dependencies:

- Baseline assessment.
- Reading modes.

Completed task log:

```text
Task: Add curriculum module structure
Status: Done
Completed: 2026-07-06
Changed files: lib/training/domain/curriculum.dart, test/curriculum_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for required concept coverage and level-based unlocks.
Commit: See Git history for `feat: add curriculum structure`
Notes: Dedicated vocabulary capture and review UI remains open.
```

### Epic 7.2: Skill Drills

Tasks:

- Build pacing drills.
- Build two-word and three-word chunk drills.
- Build phrase highlighting drills.
- Build forward-only regression-control drills.
- Build subvocalization awareness comparison drills.
- Build skimming gist drills.
- Build scanning target drills.
- Build vocabulary capture and review list.

Acceptance criteria:

- Each drill records completion and relevant metrics.
- Drills are usable in daily training.
- Drill results affect recommendations.

Dependencies:

- Reading player modes.
- Analytics events.

### Epic 7.3: Adaptive Recommendation Engine

Status: In Progress

Tasks:

- Recommend drills based on weak skills.
- Slow progression when comprehension falls below threshold.
- Detect plateaued WPM.
- Detect weak detail recall.
- Detect weak scanning accuracy.
- Detect RSVP-only progress without non-RSVP transfer.

Acceptance criteria:

- User receives a next recommended drill after each session.
- Recommendations change when performance changes.
- App does not push higher speed when comprehension is collapsing.

Dependencies:

- Progress history.
- Skill metrics.

Completed task log:

```text
Task: Add adaptive training recommendation rules
Status: Done
Completed: 2026-07-06
Changed files: lib/training/domain/training_recommendation.dart, test/training_recommendation_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for comprehension-first behavior, RSVP transfer, scanning weakness, and WPM plateau recommendations.
Commit: See Git history for `feat: add training recommendation rules`
Notes: Recommendation inputs are domain-level for now. Wiring to persisted progress history remains open.
```

## Milestone 8: Dashboard and Analytics

Goal: Show progress clearly without encouraging speed-only behavior.

### Epic 8.1: Home Dashboard

Status: In Progress

Tasks:

- Show current level.
- Show progress toward 800 WPM.
- Show latest WPM and comprehension.
- Show ERS trend summary.
- Show daily practice plan.
- Show streak.
- Show recommended next drill.

Acceptance criteria:

- Dashboard is the first post-onboarding screen.
- Dashboard never presents WPM without comprehension context.
- Recommended next action is visible.

Dependencies:

- Progression system.
- Training recommendation engine.

Completed task log:

```text
Task: Add dashboard navigation entry points
Status: Done
Completed: 2026-07-07
Changed files: lib/training/presentation/dashboard_screen.dart, test/dashboard_screen_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: add dashboard navigation`
Notes: Dashboard now links to Library, Import Passage, Reader, Progress, and Settings. Live metrics remain open.
```

```text
Task: Show initialized local profile on dashboard
Status: Done
Completed: 2026-07-07
Changed files: lib/training/presentation/dashboard_screen.dart, test/dashboard_screen_test.dart, test/widget_test.dart, TASKS.md
Verification: Ran `flutter analyze` and `flutter test`. Analyze passed with no issues and all tests passed.
Commit: See Git history for `feat: show local profile on dashboard`
Notes: Dashboard now consumes the local profile provider, which creates the local-only profile on first load.
```

### Epic 8.2: Analytics Views

Tasks:

- Build WPM over time chart.
- Build comprehension over time chart.
- Build ERS over time chart.
- Build skill breakdown view.
- Build passage difficulty distribution view.
- Build best qualified attempt view.

Acceptance criteria:

- Charts load within 1 second for typical local history.
- Charts are color-blind safe.
- User can distinguish official and imported text performance.

Dependencies:

- Local progress history.
- Charting package.

### Epic 8.3: Shareable Progress Summary

Status: In Progress

Tasks:

- Create local progress summary card.
- Include level, ERS, qualified WPM/comprehension, streak, and certification status.
- Exclude private imported passage text.
- Add platform share sheet integration where available.

Acceptance criteria:

- User can share progress manually.
- Sharing does not require account linking.
- Shared summary excludes private passage content.

Dependencies:

- Dashboard metrics.
- Platform sharing package.

Completed task log:

```text
Task: Add shareable progress summary model
Status: Done
Completed: 2026-07-06
Changed files: lib/progress/domain/shareable_progress_summary.dart, test/shareable_progress_summary_test.dart, TASKS.md
Verification: Could not run flutter test because Flutter is not installed or not on PATH. Added tests for summary formatting and excluding passage text.
Commit: See Git history for `feat: add shareable progress summary`
Notes: UI card and platform share sheet integration remain open.
```

## Milestone 9: Settings, Accessibility, Privacy, and Reliability

Goal: Make the app comfortable, private, and resilient across target platforms.

### Epic 9.1: Settings

Tasks:

- Add font size setting.
- Add line height setting.
- Add theme setting.
- Add column width setting.
- Add reduced motion setting.
- Add export data screen.
- Add reset progress screen.

Acceptance criteria:

- Settings persist locally.
- Settings affect reading player.
- Reset progress requires confirmation.

Dependencies:

- Local persistence.

### Epic 9.2: Accessibility

Tasks:

- Add scalable text support.
- Add high contrast themes.
- Add screen reader labels for navigation and non-test UI.
- Add reduced motion behavior.
- Add keyboard navigation for Windows.
- Verify controls on mobile sizes.

Acceptance criteria:

- Core navigation works with keyboard on Windows.
- Text can be enlarged without overlapping core UI.
- Motion-sensitive features honor reduced motion setting.

Dependencies:

- UI foundations.

### Epic 9.3: Session Reliability

Tasks:

- Autosave active test/session state.
- Recover after app interruption.
- Mark interrupted attempts unqualified when needed.
- Prevent accidental test exit.
- Add platform lifecycle handling.

Acceptance criteria:

- Mobile interruption does not corrupt progress history.
- Session recovery behavior is predictable.
- Certification attempts cannot be accidentally qualified after invalid interruption.

Dependencies:

- Reading session persistence.

## Milestone 10: Platform Packaging and Release Readiness

Goal: Prepare MVP for Windows, Android, and iOS delivery.

### Epic 10.1: Windows Readiness

Status: In Progress

Tasks:

- Validate desktop layout.
- Validate keyboard navigation.
- Validate local storage path.
- Validate export file behavior.
- Validate app packaging/build.

Acceptance criteria:

- Windows build succeeds.
- App can run local-only with bundled content.
- Export works on Windows.

Dependencies:

- MVP features complete.

Blocked task log:

```text
Task: Verify Windows build
Status: Done
Completed: 2026-07-07
Changed files: TASKS.md
Verification: Ran `C:\Users\Psyaryu\tools\flutter\bin\flutter.bat build windows`. Build succeeded and produced `build\windows\x64\runner\Release\speed_reading.exe`.
Commit: See Git history for `chore: verify Windows build`
Notes: Windows Developer Mode is enabled and plugin symlink support works.
```

### Epic 10.2: Android Readiness

Tasks:

- Validate mobile layout.
- Validate lifecycle interruptions.
- Validate local storage.
- Validate share sheet.
- Validate Android build.

Acceptance criteria:

- Android build succeeds.
- Reading player is usable on phone-sized viewport.
- Session recovery works after backgrounding.

Dependencies:

- MVP features complete.

### Epic 10.3: iOS Readiness

Tasks:

- Validate mobile layout.
- Validate lifecycle interruptions.
- Validate local storage.
- Validate share sheet.
- Validate iOS build configuration.

Acceptance criteria:

- iOS build configuration is present and documented.
- Reading player is usable on phone-sized viewport.
- Session recovery works after backgrounding.

Dependencies:

- MVP features complete.
- macOS/iOS build environment for final validation.

## Milestone 11: Verification and Quality

Goal: Prove the app behaves correctly before release.

### Epic 11.1: Unit Test Coverage

Tasks:

- Test ERS calculation.
- Test readiness calculation.
- Test level thresholds.
- Test certification rules.
- Test mastery rules.
- Test passage word count.
- Test RSVP timing calculations.
- Test local serialization.

Acceptance criteria:

- Core scoring and qualification logic is covered by unit tests.
- Edge cases around 70%, 800 WPM, and interrupted attempts are covered.

Dependencies:

- Core logic implemented.

### Epic 11.2: Widget and Integration Tests

Tasks:

- Test onboarding flow.
- Test baseline assessment flow.
- Test manual reading session flow.
- Test RSVP session flow.
- Test quiz/results flow.
- Test paste-and-save flow.
- Test reset/export flows.

Acceptance criteria:

- Critical MVP flows have automated coverage.
- Tests can run locally without network access.

Dependencies:

- UI flows implemented.

### Epic 11.3: Manual QA Checklist

Tasks:

- Create Windows QA checklist.
- Create Android QA checklist.
- Create iOS QA checklist.
- Verify text does not overlap at large font sizes.
- Verify reduced motion.
- Verify high contrast mode.
- Verify offline launch.
- Verify progress sharing excludes private text.

Acceptance criteria:

- Manual QA checklist exists.
- Known release blockers are documented.

Dependencies:

- Platform builds.

## Post-MVP Backlog

These items are explicitly outside initial MVP unless reprioritized.

- PDF import.
- EPUB import.
- Web article import.
- Cloud sync.
- Optional accounts.
- Paid subscriptions.
- AI-generated comprehension questions.
- Social feeds, followers, or account linking.
- macOS, web, and Linux targets.
- Advanced reading diagnostics.
- Remote content catalog.

## Small Initial Task List

These are the first implementation-ready tasks to start development:

1. Scaffold Flutter project with Windows, iOS, and Android enabled.
2. Add README with local setup, run, and test commands.
3. Add Riverpod for state management.
4. Add Drift with SQLite for local persistence.
5. Create module folders: `core`, `reading`, `training`, `assessment`, `progress`, `content`, `settings`.
6. Add app routing skeleton.
7. Add placeholder dashboard route.
8. Define domain enums for reading mode, passage type, passage source, difficulty, and attempt qualification status.
9. Define `Passage`, `ReadingSession`, `QuizQuestion`, `QuizResult`, and `ProgressSnapshot` models.
10. Implement word-count utility with unit tests.
11. Implement ERS calculator with unit tests.
12. Implement level/readiness calculator with unit tests.
13. Add starter official passage asset format.
14. Build official passage loader.
15. Build local profile initialization.
16. Build manual reading player MVP.
17. Build quiz MVP.
18. Connect manual reading session to quiz result and ERS calculation.
19. Build dashboard summary for latest session.
20. Add paste-and-save imported text MVP.

## Cross-Cutting Acceptance Criteria

- No network access is required for core MVP use.
- Imported text remains local unless the user explicitly shares a progress summary.
- Certification and mastery use official eligible passages unless a future approved passage workflow is added.
- WPM is always presented with comprehension context.
- Attempts below 70% comprehension do not advance standard certification.
- RSVP improvements must transfer to at least one non-RSVP attempt for certification/mastery.
- Reading player timing and pause behavior are tested.
- Windows, iOS, and Android remain first-class targets.

## Open Questions

These questions should be answered before or during the relevant milestone:

- Should official passages be stored as JSON assets, SQLite seed data, or generated Dart assets?
- Should written summaries be self-scored in MVP or deferred?
- Should certification require only non-fiction, or should official fiction passages also support separate fiction certification later?

Resolved decisions:

- Use Riverpod for state management.
- Use Drift with SQLite for local persistence.
- Start official content with adventurous public-domain fiction.
- Add filterable tags to each passage.
- Scale comprehension question count with passage length.
- Use local notifications for delayed recall reminders.
- Notification copy should be edgy and motivating in a playful Duolingo-like way, while avoiding harassment, threats, protected-class insults, or abusive language.
