//
//  HierarchyRow.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct HierarchyRow: View {
    let className: String
    let level: Int
    
    var body: some View {
        HStack {
            ForEach(0..<level, id: \.self) { _ in
                Text("  ")
            }
            Image(systemName: level == 0 ? "cube.fill" : "arrow.down")
                .foregroundColor(.purple)
            Text(className)
                .font(.system(.body, design: .monospaced))
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading) {
        HierarchyRow(className: "NSObject", level: 0)
        HierarchyRow(className: "UIResponder", level: 1)
        HierarchyRow(className: "UIView", level: 2)
        HierarchyRow(className: "UIButton", level: 3)
    }
    .padding()
}



