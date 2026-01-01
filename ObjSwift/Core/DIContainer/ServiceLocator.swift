//
//  ServiceLocator.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 31.12.2025.
//

import Foundation

final class ServiceLocator {
    
    // MARK: - Singleton
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private let queue = DispatchQueue(label: "com.objswift.serviceLocator", attributes: .concurrent)
    
    private init() {
        registerDefaultServices()
    }
    
    
    func register<T>(_ service: T, as type: T.Type) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.services[key] = service
        }
    }
    
    func register<T>(factory: @escaping () -> T, as type: T.Type) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.factories[key] = factory
        }
    }
    
    func resolve<T>(_ type: T.Type) throws -> T {
        let key = String(describing: type)
        
        return try queue.sync {
            // Check for existing instance
            if let service = services[key] as? T {
                return service
            }
            
            if let factory = factories[key] {
                let service = factory() as! T
                services[key] = service
                return service
            }
            
            throw ServiceLocatorError.serviceNotFound(key)
        }
    }
    
    func resolveOptional<T>(_ type: T.Type) -> T? {
        return try? resolve(type)
    }
    
    
    private func registerDefaultServices() {
        register(RuntimeBridgeService(), as: RuntimeBridgeServiceProtocol.self)
        register(KVOBridgeService(), as: KVOBridgeServiceProtocol.self)
        register(SwizzlingBridgeService(), as: SwizzlingBridgeServiceProtocol.self)
        register(SelectorBridgeService(), as: SelectorBridgeServiceProtocol.self)
    }
    
    func unregister<T>(_ type: T.Type) {
        let key = String(describing: type)
        queue.async(flags: .barrier) {
            self.services.removeValue(forKey: key)
            self.factories.removeValue(forKey: key)
        }
    }
    
    func clear() {
        queue.async(flags: .barrier) {
            self.services.removeAll()
            self.factories.removeAll()
        }
    }
}


enum ServiceLocatorError: LocalizedError {
    case serviceNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .serviceNotFound(let key):
            return "Service '\(key)' not found in ServiceLocator"
        }
    }
}

