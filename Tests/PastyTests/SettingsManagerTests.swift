import Testing
import Foundation
@testable import Pasty

@Suite(.serialized)
struct SettingsManagerTests {
    init() {
        UserDefaults.standard.removeObject(forKey: "maxHistorySize")
        UserDefaults.standard.removeObject(forKey: "hotkeyEnabled")
    }

    @MainActor
    @Test func defaultMaxHistorySize() {
        let manager = SettingsManager.shared
        #expect(manager.maxHistorySize == 10)
    }

    @MainActor
    @Test func defaultHotkeyEnabled() {
        let manager = SettingsManager.shared
        #expect(manager.hotkeyEnabled == true)
    }

    @MainActor
    @Test func setMaxHistorySize() {
        let manager = SettingsManager.shared
        manager.maxHistorySize = 25
        #expect(manager.maxHistorySize == 25)
        #expect(UserDefaults.standard.integer(forKey: "maxHistorySize") == 25)
    }

    @MainActor
    @Test func maxHistorySizeClampedLow() {
        let manager = SettingsManager.shared
        manager.maxHistorySize = 2
        #expect(manager.maxHistorySize == 5)
    }

    @MainActor
    @Test func maxHistorySizeClampedHigh() {
        let manager = SettingsManager.shared
        manager.maxHistorySize = 100
        #expect(manager.maxHistorySize == 50)
    }

    @MainActor
    @Test func setHotkeyEnabled() {
        let manager = SettingsManager.shared
        manager.hotkeyEnabled = false
        #expect(manager.hotkeyEnabled == false)
        #expect(UserDefaults.standard.bool(forKey: "hotkeyEnabled") == false)
    }
}
