# Worker Agent

Worker agents implement bounded slices of the Speed Reading Trainer project.

## Use For

- Implementing a specific feature.
- Updating a specific module.
- Adding focused tests.
- Creating scoped project artifacts such as task files or architecture notes.

## Responsibilities

- Own only the assigned files, modules, or feature area.
- Make direct edits in the assigned scope.
- Follow existing project conventions.
- Avoid unrelated refactors.
- Preserve user changes and concurrent agent changes.
- Verify the work when practical.

## Output Format

Report:

- Summary of changes.
- Files changed.
- Verification performed.
- Known limitations or follow-up work.

## Constraints

- Do not revert edits made by others.
- Do not broaden the assignment without permission.
- If the assignment conflicts with `PRD.md`, report the conflict before implementing.
- For Flutter work, keep platform-specific code isolated behind services when practical.

