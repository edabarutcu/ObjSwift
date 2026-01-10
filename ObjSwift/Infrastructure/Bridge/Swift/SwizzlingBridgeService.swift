//
//  SwizzlingBridgeService.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation

final class SwizzlingBridgeService: SwizzlingBridgeServiceProtocol {
    
    private var interceptors: [String: (AnyObject, [Any]) -> Void] = [:]
    
    func swizzleInstanceMethod(
        originalSelector: String,
        swizzledSelector: String,
        in className: String
    ) -> BridgeResult<Void> {
        do {
            try SwizzlingBridge.swizzleInstanceMethod(
                originalSelector,
                withSwizzledSelector: swizzledSelector,
                inClass: className
            )
            return .success(())
        } catch {
            let errorMessage = (error as NSError).localizedDescription
            return .failure(.swizzlingFailed(errorMessage))
        }
    }
    
    func swizzleClassMethod(
        originalSelector: String,
        swizzledSelector: String,
        in className: String
    ) -> BridgeResult<Void> {
        do {
            try SwizzlingBridge.swizzleClassMethod(
                originalSelector,
                withSwizzledSelector: swizzledSelector,
                inClass: className
            )
            return .success(())
        } catch {
            let errorMessage = (error as NSError).localizedDescription
            return .failure(.swizzlingFailed(errorMessage))
        }
    }
    
    func registerInterceptor(
        selector: String,
        in className: String,
        interceptor: @escaping (AnyObject, [Any]) -> Void
    ) -> BridgeResult<Void> {
        let key = "\(className).\(selector)"
        interceptors[key] = interceptor
        
        // Create swizzled method name
        let swizzledSelector = "swizzled_\(selector)"
        
        // This would require creating a swizzled method implementation
        // For now, we just store the interceptor
        return .success(())
    }
    
    func removeSwizzle(
        selector: String,
        in className: String
    ) -> BridgeResult<Void> {
        // Swizzling is typically not reversible
        // But we can remove interceptors
        let key = "\(className).\(selector)"
        interceptors.removeValue(forKey: key)
        
        return .success(())
    }
}



