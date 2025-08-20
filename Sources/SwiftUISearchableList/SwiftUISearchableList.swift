//
//  SwiftUISearchableList.swift
//
//
//
//

import SwiftUI

public struct SwiftUISearchableList<Item: Identifiable, RowContent: View>: View {
    @ObservedObject private var viewModel: SearchableListViewModel<Item>
    private let rowContent: (Item) -> RowContent
    private var onItemTap: ((Item) -> Void)?
    
    @State private var showSearchBar: Bool = true
    @State private var lastOffset: CGFloat = 0
    
    public init(
        viewModel: SearchableListViewModel<Item>,
        onItemTap: ((Item) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self.viewModel = viewModel
        self.onItemTap = onItemTap
        self.rowContent = rowContent
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if showSearchBar {
                SearchBarView(text: $viewModel.searchText)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 0)

                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.filteredItems) { item in
                            rowContent(item)
//                                .padding()
//                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onItemTap?(item)
                                }
                        }
                    }
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    DispatchQueue.main.async {
                        withAnimation {
                            if offset < lastOffset {
                                showSearchBar = false
                            } else if offset > lastOffset {
                                showSearchBar = true
                            }
                            lastOffset = offset
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showSearchBar)
    }
}
