import Foundation

@MainActor
@Observable
final class SettingsManager: Sendable {
    static let shared = SettingsManager()

    private let defaults: UserDefaults

    private static let maxHistorySizeKey = "maxHistorySize"
    private static let hotkeyEnabledKey = "hotkeyEnabled"
    private static let hotkeyKeyCodeKey = "hotkeyKeyCode"
    private static let hotkeyModifiersKey = "hotkeyModifiers"

    var maxHistorySize: Int {
        get {
            let value = defaults.integer(forKey: Self.maxHistorySizeKey)
            return value == 0 ? 10 : max(5, min(50, value))
        }
        set {
            defaults.set(max(5, min(50, newValue)), forKey: Self.maxHistorySizeKey)
        }
    }

    var hotkeyEnabled: Bool {
        get {
            if defaults.object(forKey: Self.hotkeyEnabledKey) == nil {
                return true
            }
            return defaults.bool(forKey: Self.hotkeyEnabledKey)
        }
        set {
            defaults.set(newValue, forKey: Self.hotkeyEnabledKey)
        }
    }

    var hotkeyKeyCode: Int {
        get {
            if defaults.object(forKey: Self.hotkeyKeyCodeKey) == nil {
                return 0x09 // kVK_ANSI_V
            }
            return defaults.integer(forKey: Self.hotkeyKeyCodeKey)
        }
        set {
            defaults.set(newValue, forKey: Self.hotkeyKeyCodeKey)
        }
    }

    var hotkeyModifiers: Int {
        get {
            if defaults.object(forKey: Self.hotkeyModifiersKey) == nil {
                return 0x0900 // cmdKey | shiftKey
            }
            return defaults.integer(forKey: Self.hotkeyModifiersKey)
        }
        set {
            defaults.set(newValue, forKey: Self.hotkeyModifiersKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}
