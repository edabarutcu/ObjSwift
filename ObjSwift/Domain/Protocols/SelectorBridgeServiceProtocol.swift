//
//  SelectorBridgeServiceProtocol.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation

protocol SelectorBridgeServiceProtocol {
    
    func perform(
        selector: String,
        on object: AnyObject,
        with arguments: [Any]?
    ) -> BridgeResult<Any?>
    
    func perform(
        selector: String,
        on object: AnyObject,
        afterDelay delay: TimeInterval,
        with arguments: [Any]?
    )
    
    func responds(to selector: String, on object: AnyObject) -> Bool
    
    func getSelectors(for object: AnyObject) -> BridgeResult<[String]>
}



