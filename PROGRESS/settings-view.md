# settings-view: Settings View (SwiftUI)

## What was implemented
- `SettingsView` SwiftUI view bound to `SettingsManager.shared`
- General section: Stepper for maxHistorySize (5–50), Toggle for hotkeyEnabled
- About section: App name, version, description
- Form layout with `.grouped` style

## Files created
- `Sources/Pasty/Views/SettingsView.swift`

## Test results
- `swift build` — ✅ compiles
