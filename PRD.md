# Product Requirements Document: Speed Reading Trainer

## 1. Overview

Speed Reading Trainer is a Flutter-based multi-platform application that teaches users to read faster through structured training, timed practice, comprehension testing, and progress scoring toward an aspirational target of 800 words per minute (WPM).

The product should be honest about the speed-comprehension trade-off. Research indicates that average adult silent reading in English is roughly 238 WPM for non-fiction and 260 WPM for fiction, with many adults falling around 175-320 WPM depending on text type and reader profile. Research also suggests that dramatic speed increases usually reduce comprehension, and that high-speed reading is often closer to skimming than deep reading. Therefore, the application should define 800 WPM as a "rapid reading" milestone that must be paired with minimum comprehension standards, not as a guarantee of full deep-reading comprehension.

## 2. Product Goal

Help users progressively improve reading efficiency until they can complete selected rapid-reading exercises at 800 WPM while maintaining an acceptable comprehension score. The minimum comprehension threshold for progression and certification is 70%, while the long-term mastery aspiration is 800 WPM with 100% comprehension on appropriate texts.

Primary target:

- Reach 800 WPM in supported practice modes.
- Maintain at least 70% comprehension on general-interest passages at the target speed.
- Provide an optional mastery path that trains toward 100% comprehension at 800 WPM.
- Build durable skills: pacing, reduced regressions, chunking, scanning, skimming, focus, vocabulary growth, and mode selection between deep reading and rapid reading.

## 3. Target Platforms

The project should be implemented in Flutter and support these deployment targets by default:

- Windows desktop
- iOS
- Android

Future targets may include macOS, web, and Linux, but they are out of scope for the initial default deployment plan.

## 4. Target Users

Primary users:

- Students who need to process assignments faster.
- Knowledge workers who read articles, reports, emails, and documentation.
- Lifelong learners who want a structured reading practice habit.

Secondary users:

- Users preparing for timed reading-heavy exams.
- Users who want better skimming and information-foraging skills.

The app is not intended to diagnose or treat dyslexia, vision problems, ADHD, or other clinical reading issues.

## 5. Research Summary

The application should be based on the following research-informed assumptions:

- Reading speed and comprehension have a trade-off. Training should measure both, not WPM alone.
- Average adult silent reading is commonly much lower than speed-reading marketing claims.
- Eye movements, fixations, saccades, regressions, and parafoveal preview are normal parts of reading.
- Eliminating subvocalization entirely is not a realistic or universally desirable goal because phonological processing supports comprehension for many readers.
- Skimming and scanning are legitimate skills when the goal is gist, triage, or finding information.
- RSVP, or rapid serial visual presentation, can help users experience faster word flow and reduce eye movement demands, but it can harm comprehension for complex text and should be used as one practice mode rather than the whole product.
- Vocabulary, background knowledge, and domain familiarity are major drivers of reading speed and comprehension.

Sources:

- Rayner, Schotter, Masson, Potter, and Treiman, "So Much to Read, So Little Time: How Do We Read, and Can Speed Reading Help?", Psychological Science in the Public Interest, 2016: https://journals.sagepub.com/doi/10.1177/1529100615623267
- Brysbaert, "How many words do we read per minute? A review and meta-analysis of reading rate", Journal of Memory and Language, 2019: https://www.sciencedirect.com/science/article/abs/pii/S0749596X19300786
- Rapid Serial Visual Presentation overview: https://en.wikipedia.org/wiki/Rapid_serial_visual_presentation

## 6. Core Learning Concepts

The curriculum should teach the following concepts in a progressive order.

### 6.1 Baseline Reading

Users start with calibrated reading passages to establish:

- Comfortable WPM
- Comprehension percentage
- Recall quality
- Regression frequency, if tracked through interaction patterns
- Self-rated focus
- Text difficulty tolerance

### 6.2 Pacing

Users learn to move through text at a steady rate using:

- Guided line pacing
- Adjustable WPM targets
- Timed reading windows
- Visual pacer overlays
- Post-passage comprehension checks

### 6.3 Chunking

Users practice recognizing groups of words rather than reading every word as an isolated unit.

Training examples:

- Two-word and three-word chunk drills
- Phrase highlighting
- Expanding fixation span exercises
- Short line-width passages that gradually widen

### 6.4 Regression Control

Users learn to reduce unnecessary rereading while preserving intentional rereading for comprehension.

Training examples:

- Forward-only reading drills
- Delayed review mode
- Confidence tagging
- Reflection prompts after comprehension scoring

### 6.5 Subvocalization Awareness

The app should not claim that users must eliminate subvocalization. Instead, it should help users notice when internal speech is useful versus when it slows simple or familiar text.

Training examples:

- Silent pacing exercises
- Familiar vocabulary speed drills
- Comparison between deep reading and rapid reading modes

### 6.6 Skimming

Users learn to extract structure and gist quickly.

Training examples:

- Headline, first sentence, and summary extraction
- Key idea selection
- Timed article previews
- Gist recall tests

### 6.7 Scanning

Users learn to locate specific information quickly.

Training examples:

- Find a date, number, name, or claim
- Timed search passages
- Distractor-heavy exercises
- Accuracy and time scoring

### 6.8 RSVP Practice

The app includes RSVP mode as a controlled practice tool.

Requirements:

- Adjustable WPM
- Word-by-word and phrase-by-phrase display
- Pause, rewind, and resume controls
- Punctuation-aware timing
- Longer pauses for sentence boundaries
- Comprehension tests after each session

### 6.9 Vocabulary and Familiarity

The app should encourage users to build vocabulary and topic familiarity because language skill is central to reading speed.

Training examples:

- Unknown word capture
- Review list
- Topic-based reading packs
- Difficulty progression by vocabulary density

## 7. Progression System

The progression system should rate progress toward 800 WPM using a composite score rather than raw speed.

### 7.1 Core Metrics

Each completed exercise records:

- WPM
- Comprehension score
- Passage difficulty
- Passage type: fiction, non-fiction, technical, academic, news, workplace, or exam-style
- Reading mode: deep read, paced read, skim, scan, RSVP
- Session duration
- Streak and consistency
- User confidence rating

### 7.2 Effective Reading Score

The app should calculate an Effective Reading Score (ERS):

```text
ERS = WPM * comprehension_multiplier * difficulty_multiplier * mode_multiplier
```

Recommended initial multipliers:

- Comprehension multiplier: comprehension percentage as decimal, with heavy penalty below 60%.
- Difficulty multiplier: 0.85 for easy, 1.0 for standard, 1.15 for hard, 1.3 for technical.
- Mode multiplier: 1.0 for paced/deep reading, 0.9 for RSVP, 0.85 for skimming, 0.8 for scanning.

Example:

```text
600 WPM * 0.75 comprehension * 1.0 standard difficulty * 1.0 paced mode = 450 ERS
```

### 7.3 800 WPM Readiness Rating

The app should show a progress rating toward the 800 WPM target:

```text
Readiness = min(100, (qualified_ERS / 800) * 100)
```

A "qualified" attempt must meet:

- At least 70% comprehension
- Passage length of at least 600 words
- Standard or higher difficulty
- No excessive pausing beyond configured limits

### 7.4 Levels

Suggested levels:

- Level 1: Baseline Reader, under 250 qualified ERS
- Level 2: Focused Reader, 250-349 qualified ERS
- Level 3: Efficient Reader, 350-449 qualified ERS
- Level 4: Fast Reader, 450-599 qualified ERS
- Level 5: Rapid Reader, 600-699 qualified ERS
- Level 6: 800 WPM Candidate, 700-799 qualified ERS
- Level 7: 800 WPM Certified, 800+ qualified ERS across at least 3 standard passages

### 7.5 Certification Rule

To earn the 800 WPM Certified status, a user must complete:

- 3 standard non-fiction passages at or above 800 WPM with at least 70% comprehension.
- At least 1 non-RSVP attempt, so the certification is not dependent on a single display method.

Delayed recall should be optional for standard certification, but required for the higher 800 WPM Mastery milestone because the mastery goal includes durable retention and near-perfect comprehension.

### 7.6 Mastery Rule

To earn 800 WPM Mastery status, a user must complete:

- 3 official standard or hard passages at or above 800 WPM with 100% immediate comprehension.
- 1 delayed recall check at least 24 hours later for each passage with at least 90% score.
- At least 1 non-RSVP attempt.
- No interrupted or excessively paused attempts.

## 8. Product Features

### 8.1 Onboarding and Assessment

Requirements:

- Explain that WPM and comprehension are both measured.
- Ask user goals: school, work, exam, personal learning, general improvement.
- Run baseline test with 2-3 passages.
- Recommend initial training level.

### 8.2 Home Dashboard

Requirements:

- Current level
- Progress toward 800 WPM
- Latest WPM and comprehension
- Effective Reading Score trend
- Daily practice plan
- Streak
- Recommended next drill

### 8.3 Training Plan

Requirements:

- Daily 10-20 minute training sessions.
- Adaptive sequencing based on weak skills.
- Mix of paced reading, chunking, RSVP, skimming, scanning, and comprehension review.
- Difficulty increases only when comprehension remains above threshold.

### 8.4 Reading Player

Requirements:

- Clean, distraction-light reading interface.
- Adjustable font size, line height, theme, and column width.
- Pacer mode.
- RSVP mode.
- Timed passage mode.
- Manual reading mode.
- Pause and resume.
- Prevent accidental exits during tests.

### 8.5 Comprehension Testing

Requirements:

- Multiple-choice questions.
- Main idea questions.
- Detail recall questions.
- Inference questions.
- Vocabulary-in-context questions.
- Optional written summary for longer passages.

### 8.6 Analytics

Requirements:

- WPM over time.
- Comprehension over time.
- ERS over time.
- Best qualified attempt.
- Skill-specific breakdown.
- Passage difficulty distribution.
- Shareable progress summary for user-initiated social posting.

### 8.7 Content Library

Requirements:

- Built-in reading packs by difficulty and topic.
- Short, medium, and public-domain long-form passages in the first release.
- Public domain or licensed text only.
- Official bundled passages should be used for certified and mastery attempts.
- Metadata for word count, grade level, topic, vocabulary density, and estimated difficulty.

### 8.8 User-Imported Text

Initial support:

- Paste text into the app.
- Automatic word count.
- Estimated difficulty.
- Practice modes available.
- Store pasted passages locally for later reuse.
- Imported text can contribute to practice history and personal analytics.
- Imported text should not be disqualified by the app because a user performs poorly on it; the app should report the result and leave text choice to the user.
- Imported text should not count toward official certification or mastery unless explicitly promoted into an approved official passage set.

Future support:

- PDF import.
- EPUB import.
- Web article import.

## 9. Functional Requirements

### 9.1 Account and Data

MVP must support local-only user profiles. Cloud sync is not part of the current product direction.

Requirements:

- Local profile creation
- Local progress history
- Locally stored pasted passages
- Export progress data as JSON or CSV
- Reset progress option with confirmation

### 9.2 Adaptive Training

The app should adjust recommendations based on:

- Recent comprehension below threshold
- Plateaued WPM
- Missed detail questions
- Weak scanning accuracy
- RSVP-only progress without manual reading transfer

### 9.3 Accessibility

Requirements:

- Scalable text
- High contrast themes
- Screen reader support for navigation and non-test UI
- Reduced motion mode
- Color-blind safe charts
- Keyboard support on Windows

### 9.4 Offline Support

Requirements:

- Core training should work offline.
- Built-in reading packs should be bundled.
- Progress should sync later if cloud sync is added.

## 10. Non-Functional Requirements

Performance:

- Reading player interactions should feel instantaneous.
- RSVP timing must be stable and precise enough for WPM training.
- Charts should load within 1 second for typical local history.

Privacy:

- User progress and imported text should remain local unless the user opts into sync.
- Imported text should not be used for training models or shared externally without explicit consent.

Reliability:

- Test sessions should autosave intermediate state.
- The app should recover cleanly after interruption, especially on mobile.

Portability:

- Use Flutter shared UI and business logic where practical.
- Keep platform-specific code isolated behind services.

## 11. Suggested Flutter Architecture

Recommended stack:

- Flutter stable channel
- Dart
- Riverpod or Bloc for state management
- GoRouter for navigation
- Drift, Isar, or SQLite for local persistence
- Freezed and json_serializable for typed models
- FL Chart or equivalent for analytics

Suggested modules:

- `core`: app configuration, routing, themes, shared utilities
- `reading`: reading player, RSVP player, pacer
- `training`: curriculum, drills, adaptive recommendations
- `assessment`: baseline tests, comprehension checks, scoring
- `progress`: ERS calculation, levels, achievements, analytics
- `content`: passage library, import pipeline, metadata
- `settings`: accessibility, account, privacy, export

## 12. MVP Scope

MVP must include:

- Flutter app targeting Windows, iOS, and Android.
- Local user profile.
- Baseline assessment.
- Reading player with manual, paced, and RSVP modes.
- Built-in public-domain long-form passage library.
- Paste-and-save local text import.
- Comprehension quizzes.
- Effective Reading Score.
- Level progression toward 800 WPM.
- Dashboard with WPM, comprehension, and readiness rating.
- Local progress persistence.
- User-initiated social sharing of progress summaries.

MVP should not include:

- Social network, follower, feed, or account-linking features
- Paid subscriptions
- AI-generated comprehension questions
- PDF or EPUB import
- Cloud sync
- Clinical reading diagnostics

## 13. Success Metrics

Product success:

- 70% of new users complete baseline assessment.
- 50% of active users complete at least 5 sessions in the first 7 days.
- 40% of users improve qualified ERS by at least 20% within 30 days.
- Users maintain average comprehension above 70% during progression.
- At least 15% of retained users reach Level 5 or higher.

Learning success:

- Users can explain when to skim versus deeply read.
- Users can improve speed without hiding comprehension loss.
- Users can transfer gains from RSVP mode to non-RSVP paced reading.

## 14. Risks and Mitigations

Risk: Users chase WPM while comprehension collapses.

Mitigation: Gate level progression with comprehension thresholds and show warnings when speed gains are low-quality.

Risk: 800 WPM creates unrealistic expectations.

Mitigation: Present 800 WPM as an advanced rapid-reading target for appropriate text types, not a universal deep-reading promise.

Risk: RSVP improvement does not transfer to normal reading.

Mitigation: Require non-RSVP qualified attempts for certification and keep RSVP as one training mode.

Risk: Text difficulty makes scores inconsistent.

Mitigation: Store difficulty metadata and use difficulty multipliers in scoring.

Risk: Mobile interruptions corrupt tests.

Mitigation: Autosave session state and clearly mark interrupted attempts as unqualified.

## 15. Open Questions

Resolved product decisions:

- Minimum comprehension score for standard progression and certification is 70%.
- The first release should include public-domain long-form text.
- Users can paste passages into the app and store them locally.
- Imported text can be used for practice and analytics, but official certification and mastery should use official bundled passages.
- The app is local-only for MVP and should not include cloud accounts or cloud sync.
- Social posting is allowed only as user-initiated sharing of progress summaries.
- Delayed recall is optional for standard certification and required for the 800 WPM Mastery milestone.
