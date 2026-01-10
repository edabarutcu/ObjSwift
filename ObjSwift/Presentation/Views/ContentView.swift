//
//  ContentView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: MainTab = .runtime
    
    enum MainTab: String, CaseIterable {
        case runtime = "Runtime"
        case kvo = "KVO"
        case swizzling = "Swizzling"
        case selectors = "Selectors"
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RuntimeInspectorView()
                .tabItem {
                    Label("Runtime", systemImage: "magnifyingglass")
                }
                .tag(MainTab.runtime)
            
            KVOExampleView()
                .tabItem {
                    Label("KVO", systemImage: "eye")
                }
                .tag(MainTab.kvo)
            
            SwizzlingExampleView()
                .tabItem {
                    Label("Swizzling", systemImage: "arrow.triangle.swap")
                }
                .tag(MainTab.swizzling)
            
            SelectorExampleView()
                .tabItem {
                    Label("Selectors", systemImage: "hand.point.up.left")
                }
                .tag(MainTab.selectors)
        }
    }
}

#Preview {
    ContentView()
}



