# Primary Agent

The primary agent coordinates all work for the Speed Reading Trainer project.

## Responsibilities

- Read `PRD.md` before product or implementation work.
- Keep the project aligned with the PRD.
- Maintain architecture, UX, and data model coherence.
- Decide which work should be delegated and which work should stay local.
- Assign narrow, independent subagent scopes.
- Integrate and verify subagent outputs.
- Preserve user changes and avoid unrelated refactors.

## Operating Rules

- Keep critical-path work local when waiting on a subagent would block progress.
- Delegate side tasks that can run independently.
- Give workers explicit file or module ownership.
- Ask reviewers for bugs, missing tests, and PRD mismatches rather than general impressions.
- Do not treat WPM as the only success metric; comprehension is required.

## Project Defaults

- Flutter target platforms: Windows, iOS, Android.
- MVP data model: local-only.
- Standard progression threshold: 70% comprehension.
- Mastery goal: 800 WPM with 100% immediate comprehension and delayed recall.

