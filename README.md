# Pasty

A macOS menu bar clipboard manager built with Swift 6 and SwiftUI.

Pasty monitors your system clipboard, stores a configurable history of copied items, and lets you recall any item via a global hotkey popup.

## Features

- **Menu Bar App** — lives in your menu bar with a clipboard icon
- **Clipboard History** — automatically captures copied text (up to 50 items)
- **Global Hotkey** — press `⌘⇧V` to open the popup from anywhere
- **Search & Filter** — quickly find items in your clipboard history
- **Keyboard Navigation** — arrow keys to browse, Enter to paste
- **Instant Paste** — select an item and it's pasted into the active app
- **Settings** — configure history size and toggle the global hotkey

## Requirements

- macOS 14.0+
- Swift 6.0+

## Build & Run

```bash
# Build
swift build

# Run
swift run Pasty

# Test
swift test
```

## Project Structure

```
Sources/Pasty/
├── PastyApp.swift              # @main SwiftUI App entry point
├── AppDelegate.swift           # Wires all managers together
├── Models/
│   ├── ClipboardItem.swift     # Clipboard history entry
│   └── SettingsManager.swift   # UserDefaults-backed preferences
├── Managers/
│   ├── ClipboardManager.swift  # Polls clipboard, manages history
│   ├── HotkeyManager.swift     # Global ⌘⇧V via Carbon API
│   └── StatusBarController.swift # Menu bar icon and dropdown
└── Views/
    ├── PopupView.swift         # Clipboard history list
    ├── PopupWindowController.swift # Floating NSPanel
    ├── ClipboardItemRow.swift  # Single row in the list
    └── SettingsView.swift      # Settings window
```

## How It Works

1. `ClipboardManager` polls `NSPasteboard.general` every 0.5s for changes
2. New clipboard content is stored as a `ClipboardItem` in an in-memory history
3. Press `⌘⇧V` → `HotkeyManager` fires → floating popup appears near cursor
4. Select an item → content is written to the pasteboard → `⌘V` is simulated via `CGEvent`

## License

MIT
