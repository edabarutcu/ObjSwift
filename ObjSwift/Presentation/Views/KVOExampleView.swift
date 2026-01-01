//
//  KVOExampleView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct KVOExampleView: View {
    @StateObject private var viewModel = KVOExampleViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Counter: \(viewModel.counter)")
                    .font(.largeTitle)
                    .bold()
                
                Text("Observations: \(viewModel.observationCount)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Button("Increment Counter") {
                    viewModel.increment()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("KVO Example")
        }
    }
}



