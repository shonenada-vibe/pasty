import Foundation

enum ContentType: String, Sendable, Equatable, Hashable {
    case plainText
    case richText
    case image
}

struct ClipboardItem: Identifiable, Equatable, Hashable, Sendable {
    let id: UUID
    let content: String
    let timestamp: Date
    let contentType: ContentType

    init(id: UUID = UUID(), content: String, timestamp: Date = Date(), contentType: ContentType = .plainText) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.contentType = contentType
    }

    var preview: String {
        if content.count > 80 {
            return String(content.prefix(80)) + "…"
        }
        return content
    }
}
