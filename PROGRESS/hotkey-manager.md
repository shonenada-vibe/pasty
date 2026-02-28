# hotkey-manager: Hotkey Manager (Carbon API)

## What was implemented
- `HotkeyManager` class with `@MainActor` and `static shared` singleton
- `register()` — installs Carbon event handler and registers Cmd+Shift+V hotkey (signature "PSTY", id 1)
- `unregister()` — removes hotkey and event handler
- Respects `SettingsManager.hotkeyEnabled` — only registers when enabled
- `onHotkeyPressed` callback closure
- Global `@MainActor` instance reference for C callback interop

## Files created
- `Sources/Pasty/Managers/HotkeyManager.swift`

## Test results
- `swift build` — ✅ compiles
