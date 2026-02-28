# project-setup: SPM Project Setup

## What was implemented
- Created `Package.swift` with Swift 6 language mode, macOS 14 platform, `Pasty` executable target, and `PastyTests` test target
- Created `Resources/Info.plist` with `LSUIElement=true` and bundle identifier `com.pasty.app`
- Created `Sources/Pasty/PastyApp.swift` with `@main` App struct containing a placeholder `WindowGroup`
- Created `Tests/PastyTests/PastyTests.swift` with a placeholder test

## Files created
- `Package.swift`
- `Resources/Info.plist`
- `Sources/Pasty/PastyApp.swift`
- `Tests/PastyTests/PastyTests.swift`

## Decisions
- Removed `Info.plist` from SPM resources since SPM forbids `Info.plist` as a top-level bundled resource. The file is kept in `Resources/` for reference.
- Added `swiftSettings: [.swiftLanguageMode(.v6)]` to enforce Swift 6 strict concurrency.

## Test results
- `swift build` — ✅ compiles successfully
- `swift test` — ✅ 1 test passed
