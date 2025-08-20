//
//  SearchableListViewModel.swift
//  
//
//
//

import Foundation
import Combine

open class SearchableListViewModel<Item: Identifiable>: ObservableObject {
    @Published public var searchText: String = ""
    @Published public private(set) var filteredItems: [Item] = []

    private var allItems: [Item]
    private var cancellables = Set<AnyCancellable>()
    private let filter: (Item, String) -> Bool

    public init(items: [Item], filter: @escaping (Item, String) -> Bool) {
        self.allItems = items
        self.filter = filter

        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] text in
                self?.filterItems(with: text) ?? []
            }
            .assign(to: &$filteredItems)
    }

    private func filterItems(with text: String) -> [Item] {
        guard !text.isEmpty else { return allItems }
        return allItems.filter { filter($0, text) }
    }
}
