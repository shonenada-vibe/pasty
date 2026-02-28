import AppKit

@MainActor
@Observable
final class ClipboardManager {
    var history: [ClipboardItem] = []
    var lastChangeCount: Int = 0

    private var timer: Timer?
    private let settings: SettingsManager

    init(settings: SettingsManager = .shared) {
        self.settings = settings
    }

    func startMonitoring() {
        lastChangeCount = NSPasteboard.general.changeCount
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.checkClipboard()
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func clearHistory() {
        history.removeAll()
    }

    func pasteItem(_ item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(item.content, forType: .string)
        lastChangeCount = pasteboard.changeCount

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.simulateCmdV()
        }
    }

    private func simulateCmdV() {
        let source = CGEventSource(stateID: .combinedSessionState)
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
        keyDown?.flags = .maskCommand
        keyDown?.post(tap: .cgSessionEventTap)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        keyUp?.flags = .maskCommand
        keyUp?.post(tap: .cgSessionEventTap)
    }

    func addItem(content: String) {
        guard !content.isEmpty else { return }
        if let first = history.first, first.content == content {
            return
        }
        let item = ClipboardItem(content: content)
        history.insert(item, at: 0)
        trimHistory()
    }

    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        let currentChangeCount = pasteboard.changeCount
        guard currentChangeCount != lastChangeCount else { return }
        lastChangeCount = currentChangeCount
        guard let content = pasteboard.string(forType: .string) else { return }
        addItem(content: content)
    }

    private func trimHistory() {
        let maxSize = settings.maxHistorySize
        if history.count > maxSize {
            history = Array(history.prefix(maxSize))
        }
    }
}
