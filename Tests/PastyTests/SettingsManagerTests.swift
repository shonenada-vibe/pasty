import Testing
import Foundation
@testable import Pasty

@Suite(.serialized)
struct SettingsManagerTests {
    private let suiteName = "SettingsManagerTests"

    @MainActor
    private func makeManager() -> SettingsManager {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return SettingsManager(defaults: defaults)
    }

    @MainActor
    @Test func defaultMaxHistorySize() {
        let manager = makeManager()
        #expect(manager.maxHistorySize == 10)
    }

    @MainActor
    @Test func defaultHotkeyEnabled() {
        let manager = makeManager()
        #expect(manager.hotkeyEnabled == true)
    }

    @MainActor
    @Test func setMaxHistorySize() {
        let manager = makeManager()
        manager.maxHistorySize = 25
        #expect(manager.maxHistorySize == 25)
    }

    @MainActor
    @Test func maxHistorySizeClampedLow() {
        let manager = makeManager()
        manager.maxHistorySize = 2
        #expect(manager.maxHistorySize == 5)
    }

    @MainActor
    @Test func maxHistorySizeClampedHigh() {
        let manager = makeManager()
        manager.maxHistorySize = 100
        #expect(manager.maxHistorySize == 50)
    }

    @MainActor
    @Test func setHotkeyEnabled() {
        let manager = makeManager()
        manager.hotkeyEnabled = false
        #expect(manager.hotkeyEnabled == false)
    }
}
