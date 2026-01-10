//
//  RuntimeInspectorView.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import SwiftUI

struct RuntimeInspectorView: View {
    
    @StateObject private var viewModel = RuntimeInspectorViewModel()
    @State private var searchText: String = ""
    @State private var selectedTab: InspectorTab = .methods
    
    enum InspectorTab: String, CaseIterable {
        case methods = "Methods"
        case properties = "Properties"
        case ivars = "Instance Variables"
        case hierarchy = "Class Hierarchy"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar
                
                if viewModel.isLoading {
                    ProgressView("Inspecting class...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !viewModel.className.isEmpty {
                    contentView
                } else {
                    emptyStateView
                }
            }
            .navigationTitle("Runtime Inspector")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Inspect") {
                        viewModel.inspectClass(searchText)
                    }
                    .disabled(searchText.isEmpty)
                }
            }
        }
    }
        
    private var searchBar: some View {
        SearchBarView(searchText: $searchText) {
            viewModel.inspectClass(searchText)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            Picker("Section", selection: $selectedTab) {
                ForEach(InspectorTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    switch selectedTab {
                    case .methods:
                        methodsView
                    case .properties:
                        propertiesView
                    case .ivars:
                        ivarsView
                    case .hierarchy:
                        hierarchyView
                    }
                }
                .padding()
            }
        }
    }
    
    private var methodsView: some View {
        Group {
            if viewModel.methods.isEmpty {
                Text("noo methods found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.methods, id: \.self) { method in
                    MethodRow(method: method)
                }
            }
        }
    }
    
    private var propertiesView: some View {
        Group {
            if viewModel.properties.isEmpty {
                Text("noo properties found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.properties) { property in
                    PropertyRow(property: property)
                }
            }
        }
    }
    
    private var ivarsView: some View {
        Group {
            if viewModel.instanceVariables.isEmpty {
                Text("noo instance variables found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.instanceVariables, id: \.self) { ivar in
                    IvarRow(ivar: ivar)
                }
            }
        }
    }
    
    private var hierarchyView: some View {
        Group {
            if viewModel.classHierarchy.isEmpty {
                Text("noo hierarchy found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(Array(viewModel.classHierarchy.enumerated()), id: \.offset) { index, className in
                    HierarchyRow(className: className, level: index)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        EmptyStateView()
    }
}

#Preview {
    RuntimeInspectorView()
}

