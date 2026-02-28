import SwiftUI

struct SettingsView: View {
    @State private var settings = SettingsManager.shared

    var body: some View {
        Form {
            Section("General") {
                Stepper("Max History Size: \(settings.maxHistorySize)",
                        value: $settings.maxHistorySize,
                        in: 5...50)

                Toggle("Global Hotkey (⌘⇧V)", isOn: $settings.hotkeyEnabled)
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
        .frame(width: 350, height: 250)
    }
}
