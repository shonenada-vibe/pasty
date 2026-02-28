# clipboard-item-model: ClipboardItem Model

## What was implemented
- `ClipboardItem` struct conforming to `Identifiable`, `Equatable`, `Hashable`, `Sendable`
- `ContentType` enum with `plainText`, `richText`, `image` cases
- Properties: `id` (UUID), `content` (String), `timestamp` (Date), `contentType` (ContentType)
- Computed `preview` property: returns first 80 chars with "…" ellipsis if truncated
- 6 unit tests covering creation, preview (short, exact 80, truncation), equality, and inequality

## Files created
- `Sources/Pasty/Models/ClipboardItem.swift`
- `Tests/PastyTests/ClipboardItemTests.swift`

## Test results
- `swift test` — ✅ 7 tests passed (including placeholder)
