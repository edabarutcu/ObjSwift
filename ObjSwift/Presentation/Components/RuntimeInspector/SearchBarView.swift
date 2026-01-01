//
//  SearchBarView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    let onSubmit: () -> Void
    
    init(
        searchText: Binding<String>,
        placeholder: String = "Enter class name (e.g., UIView)",
        onSubmit: @escaping () -> Void = {}
    ) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $searchText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    onSubmit()
                }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    SearchBarView(searchText: .constant("")) {
        print("Search submitted")
    }
}



