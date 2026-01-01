//
//  StatusCardView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct StatusCardView: View {
    let message: String
    let status: StatusType
    
    enum StatusType {
        case success
        case error
        case warning
        case info
        
        var color: Color {
            switch self {
            case .success:
                return .green
            case .error:
                return .red
            case .warning:
                return .orange
            case .info:
                return .blue
            }
        }
    }
    
    var body: some View {
        Text(message)
            .font(.body)
            .foregroundColor(status.color)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 16) {
        StatusCardView(message: "Success message", status: .success)
        StatusCardView(message: "Error message", status: .error)
        StatusCardView(message: "Warning message", status: .warning)
        StatusCardView(message: "Info message", status: .info)
    }
    .padding()
}



