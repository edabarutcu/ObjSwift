//
//  KVOBridgeServiceProtocol.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation
import Combine

protocol KVOBridgeServiceProtocol {

    func observe<T: AnyObject, Value>(
        object: T,
        keyPath: KeyPath<T, Value>,
        options: NSKeyValueObservingOptions
    ) -> AnyPublisher<Value, Never>
    

    func observe(
        object: NSObject,
        keyPath: String,
        options: NSKeyValueObservingOptions,
        callback: @escaping (Any?, [NSKeyValueChangeKey: Any]?) -> Void
    ) -> ObservationToken
    
  
    func stopObserving(_ token: ObservationToken)
}

final class ObservationToken: NSObject {
    private weak var object: NSObject?
    private let keyPath: String
    private var isObserving: Bool = false
    
    init(object: NSObject, keyPath: String) {
        self.object = object
        self.keyPath = keyPath
        super.init()
        self.isObserving = true
    }
    
    func invalidate() {
        guard isObserving, let object = object else { return }
        object.removeObserver(self, forKeyPath: keyPath)
        isObserving = false
    }
    
    deinit {
        invalidate()
    }
}

