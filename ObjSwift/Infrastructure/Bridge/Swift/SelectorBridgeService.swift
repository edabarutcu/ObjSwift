//
//  SelectorBridgeService.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation

final class SelectorBridgeService: SelectorBridgeServiceProtocol {
    
    func perform(
        selector: String,
        on object: AnyObject,
        with arguments: [Any]?
    ) -> BridgeResult<Any?> {
        let runtimeService = try! ServiceLocator.shared.resolve(RuntimeBridgeServiceProtocol.self)
        return runtimeService.callMethod(on: object, methodName: selector, arguments: arguments)
    }
    
    func perform(
        selector: String,
        on object: AnyObject,
        afterDelay delay: TimeInterval,
        with arguments: [Any]?
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak object] in
            guard let object = object else { return }
            let _ = self.perform(selector: selector, on: object, with: arguments)
        }
    }
    
    func responds(to selector: String, on object: AnyObject) -> Bool {
        let runtimeService = try! ServiceLocator.shared.resolve(RuntimeBridgeServiceProtocol.self)
        return runtimeService.responds(to: selector, on: object)
    }
    
    func getSelectors(for object: AnyObject) -> BridgeResult<[String]> {
        let className = String(describing: type(of: object))
        let runtimeService = try! ServiceLocator.shared.resolve(RuntimeBridgeServiceProtocol.self)
        return runtimeService.getMethods(for: className)
    }
}



