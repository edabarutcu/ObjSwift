//
//  KVOBridgeService.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation
import Combine

final class KVOBridgeService: KVOBridgeServiceProtocol {
    
    func observe<T: AnyObject, Value>(
        object: T,
        keyPath: KeyPath<T, Value>,
        options: NSKeyValueObservingOptions
    ) -> AnyPublisher<Value, Never> {
        guard let nsObject = object as? NSObject else {
            return Just(object[keyPath: keyPath]).eraseToAnyPublisher()
        }
       
        let subject = PassthroughSubject<Value, Never>()
      
        let token = observe(object: nsObject, keyPath: "", options: options) { value, _ in
            if let value = value as? Value {
                subject.send(value)
            }
        }
        
        objc_setAssociatedObject(subject, &AssociatedKeys.token, token, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return subject.eraseToAnyPublisher()
    }
    
    func observe(
        object: NSObject,
        keyPath: String,
        options: NSKeyValueObservingOptions,
        callback: @escaping (Any?, [NSKeyValueChangeKey: Any]?) -> Void
    ) -> ObservationToken {
        let token = ObservationToken(object: object, keyPath: keyPath)
        
        object.addObserver(
            token,
            forKeyPath: keyPath,
            options: options,
            context: nil
        )
        
        objc_setAssociatedObject(
            token,
            &AssociatedKeys.callback,
            callback,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        return token
    }
    
    func stopObserving(_ token: ObservationToken) {
        token.invalidate()
    }
}

// MARK: - KVO Observer Extension

extension ObservationToken {
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard let callback = objc_getAssociatedObject(self, &AssociatedKeys.callback) as? (Any?, [NSKeyValueChangeKey: Any]?) -> Void else {
            return
        }
        
        if let object = object as? NSObject {
            let value = object.value(forKeyPath: keyPath ?? "")
            callback(value, change)
        }
    }
}

private struct AssociatedKeys {
    static var callback = "callback"
    static var token = "token"
}

