//
//  SwizzlingExampleView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI
import Combine

struct SwizzlingExampleView: View {
    @StateObject private var viewModel = SwizzlingExampleViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Method Swizzling Demo")
                    .font(.title)
                    .bold()
                
                StatusCardView(
                    message: viewModel.statusMessage,
                    status: viewModel.isSwizzled ? .success : .warning
                )
                
                Button(viewModel.isSwizzled ? "Remove Swizzle" : "Apply Swizzle") {
                    viewModel.toggleSwizzle()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Test Method") {
                    viewModel.testMethod()
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.isSwizzled)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Swizzling Example")
        }
    }
}
