//
//  SearchBarView.swift
//  
//
//
//

import SwiftUI

public struct SearchBarView: View {
    @Binding public var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                    .padding(8)
                TextField("Search...", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .border(.gray.opacity(0.5), width: 0.3)
    }
}
