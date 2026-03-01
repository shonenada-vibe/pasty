import SwiftUI

struct SettingsView: View {
    @State private var settings = SettingsManager.shared

    var body: some View {
        Form {
            Section("General") {
                Stepper("Max History Size: \(settings.maxHistorySize)",
                        value: $settings.maxHistorySize,
                        in: 5...50)
            }

            Section("Hotkey") {
                Toggle("Enable Global Hotkey", isOn: $settings.hotkeyEnabled)

                ShortcutRecorderView {
                    HotkeyManager.shared.unregister()
                    HotkeyManager.shared.register()
                }
                .disabled(!settings.hotkeyEnabled)
            }

            Section("About") {
                LabeledContent("App", value: "Pasty")
                LabeledContent("Version", value: "1.0")
                Text("A macOS menu bar clipboard manager.")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 350)
        .onChange(of: settings.hotkeyEnabled) {
            if settings.hotkeyEnabled {
                HotkeyManager.shared.register()
            } else {
                HotkeyManager.shared.unregister()
            }
        }
    }
}
