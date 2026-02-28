# status-bar: Status Bar Controller

## What was implemented
- `StatusBarController` class with `@MainActor`
- NSStatusItem with `doc.on.clipboard` system symbol
- NSMenu with: "Show Clipboard History", separator, "Settings..." (⌘,), "Quit Pasty" (⌘Q)
- Callback closures: `onShowHistory`, `onShowSettings`, `onQuit`

## Files created
- `Sources/Pasty/Managers/StatusBarController.swift`

## Test results
- `swift build` — ✅ compiles
- `swift test` — ✅ 20 tests passed
