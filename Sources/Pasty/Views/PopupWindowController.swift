import AppKit
import SwiftUI

private class PopupPanel: NSPanel {
    var onEscape: (() -> Void)?

    override func cancelOperation(_ sender: Any?) {
        onEscape?()
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { // Escape
            onEscape?()
        } else {
            super.keyDown(with: event)
        }
    }
}

@MainActor
final class PopupWindowController {
    private var panel: NSPanel?
    private var eventMonitor: Any?

    func showPopup(items: [ClipboardItem], onSelect: @escaping (ClipboardItem) -> Void) {
        if panel != nil {
            hidePopup()
        }

        let popupView = PopupView(
            items: items,
            onSelect: { [weak self] item in
                self?.hidePopup()
                onSelect(item)
            }
        )

        let hostingView = NSHostingView(rootView: popupView)
        let contentRect = NSRect(x: 0, y: 0, width: 360, height: 400)

        let panel = PopupPanel(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.level = .floating
        panel.isFloatingPanel = true
        panel.becomesKeyOnlyIfNeeded = false
        panel.hidesOnDeactivate = false
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.contentView = hostingView
        panel.onEscape = { [weak self] in
            self?.hidePopup()
        }

        positionNearMouse(panel)
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.panel = panel

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.hidePopup()
        }
    }

    func hidePopup() {
        panel?.orderOut(nil)
        panel = nil
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }

    func toggle(items: [ClipboardItem], onSelect: @escaping (ClipboardItem) -> Void) {
        if panel != nil {
            hidePopup()
        } else {
            showPopup(items: items, onSelect: onSelect)
        }
    }

    private func positionNearMouse(_ panel: NSPanel) {
        let mouseLocation = NSEvent.mouseLocation
        let screenFrame = NSScreen.main?.visibleFrame ?? .zero
        var origin = NSPoint(x: mouseLocation.x - panel.frame.width / 2,
                             y: mouseLocation.y - panel.frame.height)

        origin.x = max(screenFrame.minX, min(origin.x, screenFrame.maxX - panel.frame.width))
        origin.y = max(screenFrame.minY, min(origin.y, screenFrame.maxY - panel.frame.height))

        panel.setFrameOrigin(origin)
    }
}
