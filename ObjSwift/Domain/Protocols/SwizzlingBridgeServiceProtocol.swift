//
//  SwizzlingBridgeServiceProtocol.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 31.12.2025.
//

import Foundation


protocol SwizzlingBridgeServiceProtocol {
    
    func swizzleInstanceMethod(
        originalSelector: String,
        swizzledSelector: String,
        in className: String
    ) -> BridgeResult<Void>
    
    func swizzleClassMethod(
        originalSelector: String,
        swizzledSelector: String,
        in className: String
    ) -> BridgeResult<Void>
    
    func registerInterceptor(
        selector: String,
        in className: String,
        interceptor: @escaping (AnyObject, [Any]) -> Void
    ) -> BridgeResult<Void>
    
    func removeSwizzle(
        selector: String,
        in className: String
    ) -> BridgeResult<Void>
}



