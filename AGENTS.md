# Agent Operating Model

These instructions define how Codex should coordinate primary and subagent work for the Speed Reading Trainer project.

## Primary Agent

The primary agent is the coordinator for each task. It is responsible for:

- Reading [PRD.md](./PRD.md) before product or implementation work.
- Maintaining product, architecture, and UX coherence.
- Creating the plan for the current task.
- Deciding which work should stay local and which work can be delegated.
- Assigning subagents narrow, independent scopes.
- Reviewing and integrating subagent outputs.
- Protecting user changes and avoiding unrelated refactors.
- Verifying the final result before reporting completion.

The primary agent should keep blocking decisions and tightly coupled implementation work local. Subagents should be used for bounded side work, independent implementation slices, review passes, or PRD breakdowns.

## Subagent Roles

Use these role definitions as operating conventions. Runtime subagents are spawned per task when the user explicitly asks for subagents, delegation, or parallel agent work.

### Explorer

Use for read-only investigation:

- Codebase orientation
- Requirement lookup
- Architecture questions
- Risk discovery
- Test strategy
- Dependency analysis

Explorers should return concise findings with file references when applicable.

### Planner

Use for product and implementation planning:

- Break PRD requirements into epics, milestones, and tasks.
- Identify dependencies and sequencing.
- Separate MVP work from later enhancements.
- Convert broad requirements into implementation-ready tickets.
- Flag open product questions and acceptance criteria gaps.

Planner agents should not change source code unless explicitly asked.

### Worker

Use for bounded implementation:

- Own a specific module, feature, or file set.
- Make direct edits only inside the assigned scope.
- Avoid unrelated refactors.
- Do not revert edits made by others.
- Report changed files and verification performed.

Workers should assume they are not alone in the codebase and should accommodate concurrent changes.

### Reviewer

Use for review-style passes:

- Find bugs, regressions, missing tests, and product mismatches.
- Check implementation against [PRD.md](./PRD.md).
- Prioritize findings by severity.
- Provide file and line references when possible.

Reviewers should not make changes unless explicitly asked.

## Project Priorities

- Build with Flutter for Windows, iOS, and Android by default.
- Keep the app local-only for MVP.
- Support user-initiated social sharing, but no social feed, followers, or account-linking features.
- Include public-domain long-form text in the first release.
- Allow users to paste passages into the app and store them locally.
- Use 70% comprehension as the standard progression and certification threshold.
- Treat 800 WPM with 100% comprehension as a mastery path, not the standard certification bar.
- Require delayed recall for 800 WPM Mastery, but keep it optional for standard certification.

## Suggested Delegation Patterns

For planning:

- Primary: define the target output and final structure.
- Planner: extract epics, milestones, dependencies, and implementation tasks from [PRD.md](./PRD.md).
- Reviewer: check the breakdown for missing requirements and oversized tasks.

For implementation:

- Primary: scaffold architecture and integrate final changes.
- Explorer: inspect existing patterns and risks.
- Worker 1: own data models and persistence.
- Worker 2: own reading player and training UI.
- Worker 3: own scoring, progression, and analytics.
- Reviewer: verify PRD alignment and test coverage.

For bug fixing:

- Primary: reproduce and isolate the bug.
- Explorer: inspect related code paths or logs.
- Worker: implement the smallest scoped fix.
- Reviewer: check for regressions and missing tests.

