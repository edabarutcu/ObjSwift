//
//  RuntimeInspectorViewModel.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//  ViewModel for Runtime Inspector View
//

import Foundation
import Combine

final class RuntimeInspectorViewModel: ObservableObject {
    
    @Published var className: String = ""
    @Published var methods: [String] = []
    @Published var properties: [PropertyInfo] = []
    @Published var instanceVariables: [String] = []
    @Published var classHierarchy: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    private let runtimeService: RuntimeBridgeServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    init(runtimeService: RuntimeBridgeServiceProtocol? = nil) {
        if let service = runtimeService {
            self.runtimeService = service
        } else {
            self.runtimeService = try! ServiceLocator.shared.resolve(RuntimeBridgeServiceProtocol.self)
        }
    }
    
    
    func inspectClass(_ className: String) {
        guard !className.isEmpty else { return }
        
        self.className = className
        isLoading = true
        errorMessage = nil
        
        Task {
            await performInspection(for: className)
        }
    }
    
    func getClasses(conformingTo protocolName: String) async -> [String] {
        let result = runtimeService.getClasses(conformingTo: protocolName)
        
        switch result {
        case .success(let classes):
            return classes
        case .failure(let error):
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return []
        }
    }
    
    
    private func performInspection(for className: String) async {
        let methodsResult = runtimeService.getMethods(for: className)
        let methods = methodsResult.value ?? []
        
        let propertiesResult = runtimeService.getProperties(for: className)
        let properties = propertiesResult.value ?? []
        
        let ivarsResult = runtimeService.getInstanceVariables(for: className)
        let ivars = ivarsResult.value ?? []
        
        let hierarchyResult = runtimeService.getClassHierarchy(for: className)
        let hierarchy = hierarchyResult.value ?? []
        
        await MainActor.run {
            self.methods = methods
            self.properties = properties
            self.instanceVariables = ivars
            self.classHierarchy = hierarchy
            self.isLoading = false
            
            if methodsResult.error != nil || propertiesResult.error != nil {
                self.errorMessage = "someee information could not be retrieved"
            }
        }
    }
}



