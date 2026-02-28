import SwiftUI

struct PopupView: View {
    let items: [ClipboardItem]
    let onSelect: (ClipboardItem) -> Void

    @State private var searchText = ""
    @State private var selectedItemID: UUID?

    private var filteredItems: [ClipboardItem] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Filter...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(8)

            if filteredItems.isEmpty {
                ContentUnavailableView {
                    Label("No Items", systemImage: "clipboard")
                } description: {
                    Text(items.isEmpty ? "Copied text will appear here." : "No items match your filter.")
                }
                .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedItemID) {
                    ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
                        ClipboardItemRow(item: item, index: index + 1)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelect(item)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
                            .tag(item.id)
                    }
                }
                .listStyle(.plain)
                .onKeyPress(.return) {
                    if let id = selectedItemID, let item = filteredItems.first(where: { $0.id == id }) {
                        onSelect(item)
                        return .handled
                    }
                    return .ignored
                }
            }
        }
        .frame(width: 360, height: 400)
    }
}
