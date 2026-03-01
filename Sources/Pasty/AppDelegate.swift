import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private let clipboardManager = ClipboardManager()
    private let statusBarController = StatusBarController()
    private let popupWindowController = PopupWindowController()
    private var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        clipboardManager.startMonitoring()
        HotkeyManager.shared.register()

        HotkeyManager.shared.onHotkeyPressed = { [weak self] in
            self?.togglePopup()
        }

        statusBarController.onShowHistory = { [weak self] in
            self?.togglePopup()
        }

        statusBarController.onShowSettings = { [weak self] in
            self?.showSettings()
        }

        statusBarController.onQuit = {
            NSApplication.shared.terminate(nil)
        }

        statusBarController.setup()
    }

    private func togglePopup() {
        popupWindowController.toggle(items: clipboardManager.history) { [weak self] item in
            self?.clipboardManager.pasteItem(item)
        }
    }

    private func showSettings() {
        NSApp.setActivationPolicy(.regular)

        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let settingsView = SettingsView()
        let hostingView = NSHostingView(rootView: settingsView)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 350),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Pasty Settings"
        window.contentView = hostingView
        window.center()
        window.isReleasedWhenClosed = false
        window.delegate = self
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow = window
    }

    func windowWillClose(_ notification: Notification) {
        if (notification.object as? NSWindow) === settingsWindow {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
