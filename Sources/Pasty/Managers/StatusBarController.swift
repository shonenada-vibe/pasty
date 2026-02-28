import AppKit

@MainActor
final class StatusBarController {
    private var statusItem: NSStatusItem?
    private var menu: NSMenu?

    var onShowHistory: (() -> Void)?
    var onShowSettings: (() -> Void)?
    var onQuit: (() -> Void)?

    func setup() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Pasty")
        }

        let menu = NSMenu()

        let showHistoryItem = NSMenuItem(title: "Show Clipboard History", action: #selector(showHistoryAction), keyEquivalent: "")
        showHistoryItem.keyEquivalentModifierMask = [.command, .shift]
        showHistoryItem.target = self
        menu.addItem(showHistoryItem)

        menu.addItem(.separator())

        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(showSettingsAction), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        let quitItem = NSMenuItem(title: "Quit Pasty", action: #selector(quitAction), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
        self.statusItem = statusItem
        self.menu = menu
    }

    @objc private func showHistoryAction() {
        onShowHistory?()
    }

    @objc private func showSettingsAction() {
        onShowSettings?()
    }

    @objc private func quitAction() {
        onQuit?()
    }
}
