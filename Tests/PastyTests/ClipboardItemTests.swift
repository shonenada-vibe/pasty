import Testing
import Foundation
@testable import Pasty

@Test func clipboardItemCreation() {
    let item = ClipboardItem(content: "Hello, world!")
    #expect(item.content == "Hello, world!")
    #expect(item.contentType == .plainText)
}

@Test func clipboardItemPreviewShortText() {
    let item = ClipboardItem(content: "Short text")
    #expect(item.preview == "Short text")
}

@Test func clipboardItemPreviewTruncation() {
    let longText = String(repeating: "a", count: 100)
    let item = ClipboardItem(content: longText)
    #expect(item.preview.count == 81) // 80 chars + ellipsis
    #expect(item.preview.hasSuffix("…"))
}

@Test func clipboardItemPreviewExactly80() {
    let text = String(repeating: "b", count: 80)
    let item = ClipboardItem(content: text)
    #expect(item.preview == text)
}

@Test func clipboardItemEquality() {
    let id = UUID()
    let date = Date()
    let item1 = ClipboardItem(id: id, content: "test", timestamp: date)
    let item2 = ClipboardItem(id: id, content: "test", timestamp: date)
    #expect(item1 == item2)
}

@Test func clipboardItemInequality() {
    let item1 = ClipboardItem(content: "hello")
    let item2 = ClipboardItem(content: "world")
    #expect(item1 != item2)
}
