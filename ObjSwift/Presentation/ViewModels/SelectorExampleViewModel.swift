//
//  SelectorExampleViewModel.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation
import Combine

final class SelectorExampleViewModel: ObservableObject {
    @Published var result: String = "No method called"
    @Published var availableSelectors: [String] = []
    
    private let selectorService: SelectorBridgeServiceProtocol
    private let testObject = SelectorTestClass()
    
    init() {
        self.selectorService = try! ServiceLocator.shared.resolve(SelectorBridgeServiceProtocol.self)
    }
    
    func callMethod(_ methodName: String) {
        let result = selectorService.perform(
            selector: methodName,
            on: testObject,
            with: nil
        )
        
        switch result {
        case .success(let value):
            if let stringValue = value as? String {
                self.result = stringValue
            } else {
                self.result = "Method executed successfully"
            }
        case .failure(let error):
            self.result = "Error: \(error.localizedDescription)"
        }
    }
    
    func loadSelectors() async {
        let result = selectorService.getSelectors(for: testObject)
        switch result {
        case .success(let selectors):
            availableSelectors = selectors
        case .failure:
            availableSelectors = []
        }
    }
}

@objc class SelectorTestClass: NSObject {
    @objc func method1() -> String {
        return "Method 1 called"
    }
    
    @objc func method2() -> String {
        return "Method 2 called"
    }
    
    @objc func method3() -> String {
        return "Method 3 called"
    }
}
