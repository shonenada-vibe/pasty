# app-integration: App Integration

## What was implemented
- `AppDelegate` as `NSApplicationDelegate` wiring all managers together
- `PastyApp` updated with `@NSApplicationDelegateAdaptor`, placeholder WindowGroup replaced with empty Settings scene
- `applicationDidFinishLaunching`: starts clipboard monitoring, registers hotkey, sets up status bar
- StatusBar → show history toggles popup, settings opens NSWindow with SettingsView, quit terminates
- HotkeyManager → toggles popup
- PopupView selection → `ClipboardManager.pasteItem` (writes to pasteboard + simulates Cmd+V)
- Settings window created as NSWindow with NSHostingView, reuses existing window if open

## Files created/modified
- `Sources/Pasty/AppDelegate.swift` (created)
- `Sources/Pasty/PastyApp.swift` (modified)

## Test results
- `swift build` — ✅ compiles
- `swift test` — ✅ 20 tests passed
