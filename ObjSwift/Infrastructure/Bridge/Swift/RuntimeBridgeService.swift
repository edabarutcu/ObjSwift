//
//  RuntimeBridgeService.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation


final class RuntimeBridgeService: RuntimeBridgeServiceProtocol {
        
    func getClasses(conformingTo protocolName: String) -> BridgeResult<[String]> {
        let classes = RuntimeBridge.getClasses(conformingTo: protocolName)
        return .success(classes)
    }
    
    func getMethods(for className: String) -> BridgeResult<[String]> {
        let methods = RuntimeBridge.getMethods(for: className)
        return .success(methods)
    }
    
    func getProperties(for className: String) -> BridgeResult<[PropertyInfo]> {
        let properties = RuntimeBridge.getProperties(for: className)
        
        let propertyInfos = properties.compactMap { dict -> PropertyInfo? in
            guard let name = dict["name"] as? String,
                  let type = dict["type"] as? String,
                  let attributes = dict["attributes"] as? [String] else {
                return nil
            }
            return PropertyInfo(name: name, type: type, attributes: attributes)
        }
        
        return .success(propertyInfos)
    }
    
    func getInstanceVariables(for className: String) -> BridgeResult<[String]> {
        let ivars = RuntimeBridge.getInstanceVariables(for: className)
        return .success(ivars)
    }
    
    
    func callMethod(on object: AnyObject, methodName: String, arguments: [Any]?) -> BridgeResult<Any?> {
        do {
            let result = try RuntimeBridge.callMethod(methodName, on: object, withArguments: arguments)
            return .success(result)
        } catch {
            return .failure(.runtimeError(error.localizedDescription))
        }
    }
    
    func responds(to selector: String, on object: AnyObject) -> Bool {
        return RuntimeBridge.responds(to: selector, on: object)
    }
    
    
    func getSuperclass(of className: String) -> String? {
        return RuntimeBridge.getSuperclass(of: className)
    }
    
    func getClassHierarchy(for className: String) -> BridgeResult<[String]> {
        let hierarchy = RuntimeBridge.getClassHierarchy(for: className)
        return .success(hierarchy)
    }
        
    func getTypeEncoding(for propertyName: String, in className: String) -> BridgeResult<String> {
        do {
            let encoding = try RuntimeBridge.getTypeEncoding(forProperty: propertyName, inClass: className)
            return .success(encoding)
        } catch {
            return .failure(.runtimeError(error.localizedDescription))
        }
    }
}

