# PROJECT_CONTEXT.md — Pasty Technical Reference

## Overview
**Pasty** is a macOS menu bar clipboard manager. It monitors the system clipboard, stores a configurable history of copied items, and lets users recall any item via a global hotkey popup (Cmd+Shift+V).

## Tech Stack
| Component | Technology |
|-----------|-----------|
| Language | Swift 6 (strict concurrency) |
| UI | SwiftUI + AppKit |
| Build | Swift Package Manager |
| Global Hotkey | Carbon API (`RegisterEventHotKey`) |
| Clipboard | `NSPasteboard.general` (timer-polling) |
| Settings | `UserDefaults` / `@AppStorage` |
| Min Deploy | macOS 14.0 |

## Architecture

### App Lifecycle
```
PastyApp (@main, SwiftUI App)
  └── AppDelegate (NSApplicationDelegate)
        ├── StatusBarController  →  menu bar icon + dropdown menu
        ├── ClipboardManager     →  polls clipboard, stores history
        ├── HotkeyManager        →  global Cmd+Shift+V registration
        └── PopupWindowController → shows/hides clipboard popup
```

### Data Flow
1. `ClipboardManager` polls `NSPasteboard.general` every 0.5s
2. On new content → creates `ClipboardItem` → prepends to history array
3. History is capped at `SettingsManager.maxHistorySize` (default: 10)
4. User presses Cmd+Shift+V → `HotkeyManager` fires → `PopupWindowController.toggle()`
5. User clicks item → paste action writes to `NSPasteboard` → simulates Cmd+V

### Key Design Decisions
- **No external dependencies.** Carbon API for hotkeys (no HotKey package).
- **`@MainActor` by default.** All UI and manager classes run on the main actor.
- **`@Observable` macro.** Use `@Observable` (not `ObservableObject`) for Swift 6.
- **NSPanel for popup.** Allows the popup to appear above other apps without activating Pasty.
- **Timer-based polling.** macOS has no clipboard change notification; polling is the standard approach.

## Project Structure
```
pasty/
├── Package.swift                        # SPM manifest
├── Sources/Pasty/
│   ├── PastyApp.swift                   # @main SwiftUI App entry point
│   ├── AppDelegate.swift                # NSApplicationDelegate, wires managers
│   ├── Models/
│   │   ├── ClipboardItem.swift          # struct: id, content, timestamp, contentType
│   │   └── SettingsManager.swift        # @Observable, UserDefaults-backed
│   ├── Managers/
│   │   ├── ClipboardManager.swift       # Polls NSPasteboard, manages [ClipboardItem]
│   │   ├── HotkeyManager.swift          # Carbon RegisterEventHotKey wrapper
│   │   └── StatusBarController.swift    # NSStatusItem setup and menu
│   └── Views/
│       ├── PopupView.swift              # SwiftUI list of clipboard items
│       ├── PopupWindowController.swift  # NSPanel management
│       ├── ClipboardItemRow.swift       # Single row in the popup list
│       └── SettingsView.swift           # Settings window UI
├── Tests/PastyTests/
│   ├── ClipboardItemTests.swift
│   ├── ClipboardManagerTests.swift
│   └── SettingsManagerTests.swift
├── Resources/
│   └── Info.plist                       # LSUIElement = true
├── CLAUDE.md                            # This agent workflow
├── PROJECT_CONTEXT.md                   # This file
├── tasks.json                           # Task tracker
└── PROGRESS/                            # Per-task progress notes
```

## Coding Conventions

### Swift Style
- **Swift 6 strict concurrency.** Enable in Package.swift.
- **`@MainActor`** on all classes that touch UI or AppKit.
- **`@Observable`** macro for observable state (not `ObservableObject`/`@Published`).
- **`let` over `var`** — prefer immutable bindings.
- **No force-unwraps** (`!`) except for IB outlets or cases documented as safe.
- **Guard-early, return-early** — avoid deep nesting.

### Naming
- Types: `UpperCamelCase` (e.g., `ClipboardItem`, `HotkeyManager`)
- Properties/methods: `lowerCamelCase` (e.g., `maxHistorySize`, `startMonitoring()`)
- Constants: `lowerCamelCase` (e.g., `defaultMaxHistory`)
- Files match their primary type name (e.g., `ClipboardManager.swift`)

### Error Handling
- Use `do/catch` or optional chaining for recoverable errors
- Log errors to `os.Logger` (category: "Pasty")
- Never silently swallow errors

### Imports
- Import only what's needed: `import AppKit`, `import SwiftUI`, `import Carbon`
- Don't import `Cocoa` (prefer specific frameworks)

## Package.swift Reference
```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pasty",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Pasty",
            path: "Sources/Pasty",
            resources: [.copy("../../Resources/Info.plist")]
        ),
        .testTarget(
            name: "PastyTests",
            dependencies: ["Pasty"],
            path: "Tests/PastyTests"
        ),
    ]
)
```

## Key APIs

### NSPasteboard (Clipboard)
```swift
let pasteboard = NSPasteboard.general
let changeCount = pasteboard.changeCount  // Detect changes
let string = pasteboard.string(forType: .string)
pasteboard.clearContents()
pasteboard.setString(text, forType: .string)
```

### Carbon Hotkey
```swift
import Carbon

var hotkeyRef: EventHotKeyRef?
var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                              eventKind: UInt32(kEventHotKeyPressed))
let hotkeyID = EventHotKeyID(signature: OSType(0x50535459), // "PSTY"
                              id: 1)
RegisterEventHotKey(UInt32(kVK_ANSI_V),
                    UInt32(cmdKey | shiftKey),
                    hotkeyID, GetEventDispatcherTarget(), 0, &hotkeyRef)
```

### NSPanel (Popup Window)
```swift
let panel = NSPanel(contentRect: rect,
                    styleMask: [.nonactivatingPanel, .titled, .resizable],
                    backing: .buffered, defer: false)
panel.level = .floating
panel.isFloatingPanel = true
panel.hidesOnDeactivate = false
```

### Simulating Cmd+V
```swift
let source = CGEventSource(stateID: .hidEventState)
let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)  // V key
keyDown?.flags = .maskCommand
keyDown?.post(tap: .cghidEventTap)
let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
keyUp?.flags = .maskCommand
keyUp?.post(tap: .cghidEventTap)
```

## Testing Strategy
- **Unit tests** for `ClipboardItem` (creation, equality)
- **Unit tests** for `SettingsManager` (defaults, persistence)
- **Unit tests** for `ClipboardManager` (add item, max size, dedup)
- **Manual testing** for UI, hotkey, paste action (require running app)
