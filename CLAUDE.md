# CLAUDE.md — Pasty Agent Workflow

## Quick Reference
- **Build:** `swift build`
- **Run:** `swift run Pasty`
- **Test:** `swift test`
- **Clean:** `swift package clean`

## Agent Workflow (7 Steps)

### Step 1: Initialize Environment
```bash
cd /Users/shonenada/Projects/shonenada-vibe/pasty
swift build  # Verify project compiles
```

### Step 2: Select Task
- Read `tasks.json` to find the next task where `passes` is `false`
- Check that all `dependencies` for the task have `passes: true`
- Read the task's `steps` array to understand what to implement

### Step 3: Implement
- Read `PROJECT_CONTEXT.md` for architecture, conventions, and file map
- Create/edit source files under `Sources/Pasty/`
- Follow the coding conventions (Swift 6, `@MainActor`, `@Observable`, etc.)
- Keep changes focused on the current task only

### Step 4: Test
- Run `swift build` — must compile with zero errors
- Run `swift test` — all tests must pass
- For UI tasks, verify with `swift run Pasty` if possible
- Check for warnings and fix any that are introduced by the task

### Step 5: Record Progress
- Create `PROGRESS/<task-id>.md` with:
  - What was implemented
  - Files created/modified
  - Any decisions or deviations from the plan
  - Test results

### Step 6: Commit
```bash
git add -A
git commit -m "<task-id>: <short description>"
```

### Step 7: Mark Done
- In `tasks.json`, set the task's `passes` field to `true`
- Commit the updated `tasks.json`

## Rules
- **One task at a time.** Do not skip ahead or combine tasks.
- **Dependencies first.** Never start a task whose dependencies are not complete.
- **Compile always.** The project must compile after every commit.
- **No external deps.** Everything uses Apple frameworks only (AppKit, SwiftUI, Carbon).
- **Minimal changes.** Only modify files relevant to the current task.
