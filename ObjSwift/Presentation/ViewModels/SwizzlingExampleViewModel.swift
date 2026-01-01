//
//  SwizzlingExampleViewModel.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation
import Combine

final class SwizzlingExampleViewModel: ObservableObject {
    @Published var isSwizzled: Bool = false
    @Published var statusMessage: String = "not swizzled dou you here me!!!!!şaka"
    
    private let swizzlingService: SwizzlingBridgeServiceProtocol
    private let testObject = SwizzleTestClass()
    
    init() {
        self.swizzlingService = try! ServiceLocator.shared.resolve(SwizzlingBridgeServiceProtocol.self)
    }
    
    func toggleSwizzle() {
        if isSwizzled {
            removeSwizzle()
        } else {
            applySwizzle()
        }
    }
    
    private func applySwizzle() {
        let result = swizzlingService.swizzleInstanceMethod(
            originalSelector: "originalMethod",
            swizzledSelector: "swizzledMethod",
            in: "SwizzleTestClass"
        )
        
        switch result {
        case .success:
            isSwizzled = true
            statusMessage = "swizzling applied successfully!"
        case .failure(let error):
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }
    
    private func removeSwizzle() {
        let result = swizzlingService.removeSwizzle(
            selector: "originalMethod",
            in: "SwizzleTestClass"
        )
        
        switch result {
        case .success:
            isSwizzled = false
            statusMessage = "ssswizzling removed"
        case .failure(let error):
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }
    
    func testMethod() {
        testObject.originalMethod()
    }
}

@objc class SwizzleTestClass: NSObject {
    @objc func originalMethod() {}
    
    @objc func swizzledMethod() {
        swizzledMethod()
    }
}

