import Foundation

@MainActor
@Observable
final class SettingsManager: Sendable {
    static let shared = SettingsManager()

    private static let maxHistorySizeKey = "maxHistorySize"
    private static let hotkeyEnabledKey = "hotkeyEnabled"
    private static let defaultMaxHistorySize = 10
    private static let defaultHotkeyEnabled = true

    var maxHistorySize: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: Self.maxHistorySizeKey)
            return value == 0 ? Self.defaultMaxHistorySize : max(5, min(50, value))
        }
        set {
            UserDefaults.standard.set(max(5, min(50, newValue)), forKey: Self.maxHistorySizeKey)
        }
    }

    var hotkeyEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: Self.hotkeyEnabledKey) == nil {
                return Self.defaultHotkeyEnabled
            }
            return UserDefaults.standard.bool(forKey: Self.hotkeyEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.hotkeyEnabledKey)
        }
    }

    private init() {}
}
