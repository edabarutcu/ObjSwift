//
//  KVOExampleViewModel.swift
//  ObjSwift
//
//  Created by Eda Barutçu on 1.01.2026.
//

import Foundation
import Combine

final class KVOExampleViewModel: ObservableObject {
    
    @Published var counter: Int = 0
    @Published var observationCount: Int = 0
    
    private let kvoService: KVOBridgeServiceProtocol
    private var observationToken: ObservationToken?
    private var cancellables = Set<AnyCancellable>()
    
    private let observableObject = ObservableCounter()
    
    init() {
        self.kvoService = try! ServiceLocator.shared.resolve(KVOBridgeServiceProtocol.self)
        self.setupObservation()
    }
    
    private func setupObservation() {
        observationToken = kvoService.observe(
            object: observableObject,
            keyPath: "counter",
            options: [.new, .old]
        ) { [weak self] newValue, change in
            Task { @MainActor in
                self?.observationCount += 1
                if let newValue = newValue as? Int {
                    self?.counter = newValue
                }
            }
        }
    }
    
    func increment() {
        observableObject.increment()
    }
    
    deinit {
        observationToken?.invalidate()
    }
}

final class ObservableCounter: NSObject {
    @objc dynamic var counter: Int = 0
    
    func increment() {
        counter += 1
    }
}
