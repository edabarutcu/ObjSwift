//
//  PropertyRow.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct PropertyRow: View {
    let property: PropertyInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.green)
                Text(property.name)
                    .font(.system(.headline, design: .monospaced))
                Spacer()
            }
            
            Text("Type: \(property.type)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PropertyRow(property: PropertyInfo(
        name: "backgroundColor",
        type: "UIColor",
        attributes: ["nonatomic", "strong"]
    ))
    .padding()
}



