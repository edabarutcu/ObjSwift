//
//  SelectorExampleView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI
import Combine

struct SelectorExampleView: View {
    @StateObject private var viewModel = SelectorExampleViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Selector Demo")
                    .font(.title)
                    .bold()
                
                ResultCardView(
                    title: "Result",
                    value: viewModel.result
                )
                
                VStack(spacing: 12) {
                    Button("Call method1") {
                        viewModel.callMethod("method1")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Call method2") {
                        viewModel.callMethod("method2")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Call method3") {
                        viewModel.callMethod("method3")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Divider()
                
                Text("Available Selectors:")
                    .font(.headline)
                
                ScrollView {
                    ForEach(viewModel.availableSelectors, id: \.self) { selector in
                        SelectorListRow(selector: selector)
                    }
                }
                .frame(maxHeight: 200)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Selectors Example")
            .task {
                await viewModel.loadSelectors()
            }
        }
    }
}


