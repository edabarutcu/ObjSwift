//
//  RuntimeBridgeServiceProtocol.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation


protocol RuntimeBridgeServiceProtocol {
    
    
    func getClasses(conformingTo protocolName: String) -> BridgeResult<[String]>
    
    func getMethods(for className: String) -> BridgeResult<[String]>
    
    func getProperties(for className: String) -> BridgeResult<[PropertyInfo]>
    
    func getInstanceVariables(for className: String) -> BridgeResult<[String]>
    
    func callMethod(on object: AnyObject, methodName: String, arguments: [Any]?) -> BridgeResult<Any?>
    
    func responds(to selector: String, on object: AnyObject) -> Bool
    
    func getSuperclass(of className: String) -> String?
    
    func getClassHierarchy(for className: String) -> BridgeResult<[String]>
    
    func getTypeEncoding(for propertyName: String, in className: String) -> BridgeResult<String>
}

struct PropertyInfo: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let type: String
    let attributes: [String]
    
    static func == (lhs: PropertyInfo, rhs: PropertyInfo) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
    }
}



