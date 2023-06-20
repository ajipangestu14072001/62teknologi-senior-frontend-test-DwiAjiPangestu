//
//  SearchBarView.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation
import SwiftUI
import Combine

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    var onSearchTextChange: (String) -> Void
    var onCancelButtonClicked: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                isSearching = isEditing
            }, onCommit: {
                onSearchTextChange(searchText)
            })
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                let searchText = self.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                onSearchTextChange(searchText)
            }

            if isSearching {
                Button(action: {
                    onCancelButtonClicked()
                }) {
                    Text("Cancel")
                }
            }
        }
        .padding(.horizontal)
    }
}
