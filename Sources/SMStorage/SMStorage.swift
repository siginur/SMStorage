//
//  SMStorage.swift
//
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

open class SMStorage<Key: StorageKey> {
    
    private let userDefaults: UserDefaults!
    private var memory: [String: Any]!
    public let type: StorageType
    
    private init() {
        self.type = .unknown
        self.userDefaults = nil
        self.memory = nil
    }
    
    public init(userDefaults: UserDefaults) {
        self.type = .userDefaults
        self.userDefaults = userDefaults
        self.memory = nil
    }
    
    public init(memoryInitial: [String: Any]) {
        self.type = .memory
        self.userDefaults = nil
        self.memory = memoryInitial
    }
    
    public final subscript(_ key: Key) -> Any? {
        get {
            switch self.type {
            case .userDefaults:
                return userDefaults.object(forKey: key.key)
            case .memory:
                return memory[key.key]
            case .unknown:
                return nil
            }
        }
        set {
            switch self.type {
            case .userDefaults:
                userDefaults.set(newValue, forKey: key.key)
            case .memory:
                memory[key.key] = newValue
            case .unknown:
                break
            }
        }
    }
    
    public final subscript(_ key: Key) -> StorageValue {
        get {
            return StorageValue(self[key] as Any?)
        }
    }
    
    public func remove(_ key: Key) {
        switch self.type {
        case .userDefaults:
            userDefaults.removeObject(forKey: key.key)
        case .memory:
            memory.removeValue(forKey: key.key)
        case .unknown:
            break
        }
    }

}
