//
//  Result+Extensions.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation

enum BridgeError: LocalizedError {
    case runtimeError(String)
    case methodNotFound(String)
    case invalidSelector(String)
    case swizzlingFailed(String)
    case kvoError(String)
    case typeMismatch(String)
    case invalidOperation(String)
    
    var errorDescription: String? {
        switch self {
        case .runtimeError(let message):
            return "Runtime Error: \(message)"
        case .methodNotFound(let method):
            return "Method '\(method)' not found"
        case .invalidSelector(let selector):
            return "Invalid selector: \(selector)"
        case .swizzlingFailed(let reason):
            return "Method swizzling failed: \(reason)"
        case .kvoError(let message):
            return "KVO Error: \(message)"
        case .typeMismatch(let expected):
            return "Type mismatch: Expected \(expected)"
        case .invalidOperation(let operation):
            return "Invalid operation: \(operation)"
        }
    }
}

typealias BridgeResult<T> = Result<T, BridgeError>

extension Result where Failure == BridgeError {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: BridgeError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}



