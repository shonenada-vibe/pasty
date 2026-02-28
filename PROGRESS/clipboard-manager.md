# clipboard-manager: Clipboard Manager

## What was implemented
- `ClipboardManager` class with `@Observable`, `@MainActor`
- Properties: `history` ([ClipboardItem]), `lastChangeCount` (Int)
- `startMonitoring()` / `stopMonitoring()` using Timer polling NSPasteboard every 0.5s
- `addItem(content:)` with consecutive duplicate detection and empty content skip
- `clearHistory()` to empty the history array
- History trimmed to `SettingsManager.maxHistorySize`
- Dependency injection of `SettingsManager` for testability
- 7 unit tests covering add, prepend, dedup, non-consecutive duplicates, empty skip, max size, and clear

## Files created/modified
- `Sources/Pasty/Managers/ClipboardManager.swift` (created)
- `Tests/PastyTests/ClipboardManagerTests.swift` (created)
- `Sources/Pasty/Models/SettingsManager.swift` (modified: added DI for UserDefaults)
- `Tests/PastyTests/SettingsManagerTests.swift` (modified: isolated UserDefaults per suite)

## Decisions
- Added `UserDefaults` dependency injection to `SettingsManager` to fix test isolation (concurrent test suites were sharing UserDefaults keys)
- Added `SettingsManager` injection to `ClipboardManager` for the same reason

## Test results
- `swift test` — ✅ 20 tests passed
