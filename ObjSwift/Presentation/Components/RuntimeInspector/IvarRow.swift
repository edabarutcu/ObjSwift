//
//  IvarRow.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct IvarRow: View {
    let ivar: String
    
    var body: some View {
        HStack {
            Image(systemName: "variable")
                .foregroundColor(.orange)
            Text(ivar)
                .font(.system(.body, design: .monospaced))
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    IvarRow(ivar: "_delegate")
        .padding()
}



