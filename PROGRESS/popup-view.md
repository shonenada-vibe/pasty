# popup-view: Popup View (SwiftUI)

## What was implemented
- `ClipboardItemRow` — single row showing 1-based index, preview text, relative timestamp, and hover highlight
- `PopupView` — SwiftUI view with filter TextField and List of ClipboardItemRow
- Accepts `items: [ClipboardItem]` and `onSelect: (ClipboardItem) -> Void`
- Search/filter TextField filters items by content (case-insensitive)
- "No Items" placeholder when history is empty or no filter matches

## Files created
- `Sources/Pasty/Views/ClipboardItemRow.swift`
- `Sources/Pasty/Views/PopupView.swift`

## Test results
- `swift build` — ✅ compiles
