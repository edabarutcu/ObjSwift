//
//  SelectorListRow.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct SelectorListRow: View {
    let selector: String
    
    var body: some View {
        HStack {
            Image(systemName: "hand.point.up.left")
                .foregroundColor(.blue)
            Text(selector)
                .font(.system(.body, design: .monospaced))
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    VStack {
        SelectorListRow(selector: "method1")
        SelectorListRow(selector: "method2:")
        SelectorListRow(selector: "method3:withObject:")
    }
    .padding()
}



