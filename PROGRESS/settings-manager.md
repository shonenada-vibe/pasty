# settings-manager: Settings Manager

## What was implemented
- `SettingsManager` class with `@Observable`, `@MainActor`, `Sendable`, and `static let shared` singleton
- `maxHistorySize` (Int, default 10, clamped to 5–50) backed by UserDefaults
- `hotkeyEnabled` (Bool, default true) backed by UserDefaults
- 6 unit tests covering defaults, persistence, and clamping

## Files created
- `Sources/Pasty/Models/SettingsManager.swift`
- `Tests/PastyTests/SettingsManagerTests.swift`

## Test results
- `swift test` — ✅ 13 tests passed
