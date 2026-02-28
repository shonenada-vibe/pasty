# popup-window: Popup Window Controller

## What was implemented
- `PopupWindowController` class with `@MainActor`
- NSPanel with `.nonactivatingPanel`, `.titled`, `.resizable`, `.fullSizeContentView`
- `panel.level = .floating`, transparent titlebar
- `showPopup(items:onSelect:)` — hosts PopupView, positions near mouse cursor
- `hidePopup()` — dismisses panel and removes event monitor
- `toggle(items:onSelect:)` — show/hide toggle
- Click-outside dismissal via global NSEvent monitor

## Files created
- `Sources/Pasty/Views/PopupWindowController.swift`

## Test results
- `swift build` — ✅ compiles
