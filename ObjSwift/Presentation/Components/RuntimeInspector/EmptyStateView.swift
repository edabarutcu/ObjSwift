//
//  EmptyStateView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Enter a class name to inspect")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Try: UIView, UIViewController, NSObject")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView()
}



