//
//  MethodRow.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 31.12.2025.
//

import SwiftUI

struct MethodRow: View {
    let method: String
    
    var body: some View {
        HStack {
            Image(systemName: "function")
                .foregroundColor(.blue)
            Text(method)
                .font(.system(.body, design: .monospaced))
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    MethodRow(method: "viewDidLoad")
        .padding()
}



