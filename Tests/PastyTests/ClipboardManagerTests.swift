import Testing
import Foundation
@testable import Pasty

@Suite(.serialized)
struct ClipboardManagerTests {
    private let suiteName = "ClipboardManagerTests"

    @MainActor
    private func makeManager(maxHistorySize: Int = 10) -> ClipboardManager {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let settings = SettingsManager(defaults: defaults)
        settings.maxHistorySize = maxHistorySize
        return ClipboardManager(settings: settings)
    }

    @MainActor
    @Test func addItem() {
        let manager = makeManager()
        manager.addItem(content: "Hello")
        #expect(manager.history.count == 1)
        #expect(manager.history[0].content == "Hello")
    }

    @MainActor
    @Test func addItemPrepends() {
        let manager = makeManager()
        manager.addItem(content: "First")
        manager.addItem(content: "Second")
        #expect(manager.history.count == 2)
        #expect(manager.history[0].content == "Second")
        #expect(manager.history[1].content == "First")
    }

    @MainActor
    @Test func deduplicateConsecutive() {
        let manager = makeManager()
        manager.addItem(content: "Same")
        manager.addItem(content: "Same")
        #expect(manager.history.count == 1)
    }

    @MainActor
    @Test func allowNonConsecutiveDuplicates() {
        let manager = makeManager()
        manager.addItem(content: "A")
        manager.addItem(content: "B")
        manager.addItem(content: "A")
        #expect(manager.history.count == 3)
    }

    @MainActor
    @Test func skipEmptyContent() {
        let manager = makeManager()
        manager.addItem(content: "")
        #expect(manager.history.isEmpty)
    }

    @MainActor
    @Test func maxSizeEnforced() {
        let manager = makeManager(maxHistorySize: 5)
        for i in 0..<10 {
            manager.addItem(content: "Item \(i)")
        }
        #expect(manager.history.count == 5)
        #expect(manager.history[0].content == "Item 9")
    }

    @MainActor
    @Test func clearHistory() {
        let manager = makeManager()
        manager.addItem(content: "A")
        manager.addItem(content: "B")
        manager.clearHistory()
        #expect(manager.history.isEmpty)
    }
}
