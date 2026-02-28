# paste-action: Paste Action

## What was implemented
- `ClipboardManager.pasteItem(_:)` — writes item content to NSPasteboard, updates lastChangeCount to avoid re-capture
- `simulateCmdV()` — uses CGEvent to simulate Cmd+V keyDown/keyUp after 0.05s delay
- Popup hiding is handled by PopupWindowController (caller responsibility)

## Files modified
- `Sources/Pasty/Managers/ClipboardManager.swift`

## Test results
- `swift build` — ✅ compiles
- `swift test` — ✅ 20 tests passed
