//
//  SMStorage.swift
//
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

open class SMStorage<Key: StorageKey> {
    
    private let userDefaults: UserDefaults!
    private var memory: [Key: Any]!
    private let rootPath: URL?
    private let fileManager = FileManager.default
    public let type: StorageType
    
    // MARK: - Initializers
    
    private init() {
        self.type = .unknown
        self.userDefaults = nil
        self.memory = nil
        self.rootPath = nil
    }
    
    private init(type: StorageType, userDefaults: UserDefaults? = nil, memory: [Key : Any]? = nil, rootPath: URL? = nil) {
        self.type = type
        self.userDefaults = userDefaults
        self.memory = memory
        self.rootPath = rootPath
    }
    
    @available(*, deprecated, renamed: "userDefaults(_:)", message: "Use static method for initialization")
    public init(userDefaults: UserDefaults) {
        self.type = .userDefaults
        self.userDefaults = userDefaults
        self.memory = nil
        self.rootPath = nil
    }
    
    @available(*, deprecated, renamed: "memory(initialValue:)", message: "Use static method for initialization")
    public init(memoryInitial: [Key: Any]) {
        self.type = .memory
        self.userDefaults = nil
        self.memory = memoryInitial
        self.rootPath = nil
    }
    
    public static func userDefaults(_ userDefaults: UserDefaults = UserDefaults.standard) -> SMStorage<Key> {
        return SMStorage<Key>(type: .userDefaults, userDefaults: userDefaults)
    }
    
    public static func memory(initialValue: [Key: Any] = [:]) -> SMStorage<Key> {
        return SMStorage<Key>(type: .memory, memory: initialValue)
    }
    
    public static func files(inRootPath rootPath: URL) -> SMStorage<Key> {
        return SMStorage<Key>(type: .files, rootPath: rootPath)
    }
    
    public static func files() -> SMStorage<Key> where Key.KeyType == URL {
        return SMStorage<Key>(type: .files, rootPath: nil)
    }
    
    public static func files() -> SMStorage<Key> where Key == URL {
        return SMStorage<Key>(type: .files, rootPath: nil)
    }
    
    // MARK: - Subscripts
    
    public final subscript(_ key: Key) -> Any? {
        get {
            switch self.type {
            case .userDefaults:
                return userDefaults.object(forKey: key.key.description)
            case .memory:
                return memory[key]
            case .files:
                guard let url = fileUrl(withKey: key) else {
                    return nil
                }
                return try? Data(contentsOf: url)
            case .unknown:
                return nil
            }
        }
        set {
            switch self.type {
            case .userDefaults:
                userDefaults.set(newValue, forKey: key.key.description)
            case .memory:
                memory[key] = newValue
            case .files:
                if let url = fileUrl(withKey: key), let newValue = newValue as? Data {
                    try? newValue.write(to: url)
                }
            case .unknown:
                break
            }
        }
    }
    
    public final subscript<Value>(_ key: Key) -> Value? {
        return (self[key] as Any?) as? Value
    }
    
    public final subscript(_ key: Key) -> StorageValue {
        get {
            return StorageValue(self[key] as Any?)
        }
    }
    
    // MARK: - Operations
    
    public func remove(_ key: Key) {
        switch self.type {
        case .userDefaults:
            userDefaults.removeObject(forKey: key.key.description)
        case .memory:
            memory.removeValue(forKey: key)
        case .files:
            guard let url = fileUrl(withKey: key) else {
                return
            }
            try? fileManager.removeItem(at: url)
        case .unknown:
            break
        }
    }
    
    public func contain(key: Key) -> Bool {
        switch self.type {
        case .userDefaults:
            return userDefaults.object(forKey: key.key.description) != nil
        case .memory:
            return memory.keys.contains(key)
        case .files:
            guard let url = fileUrl(withKey: key) else {
                return false
            }
            return fileManager.fileExists(atPath: url.path)
        case .unknown:
            return false
        }
    }
    
    // MARK: - Help methods
    
    func fileUrl(withKey key: Key) -> URL? {
        return rootPath?.appendingPathComponent(key.key.description) ?? key as? URL ?? URL(string: key.key.description)
    }

}


// MARK: - Default generic type initializers

public extension SMStorage {
    
    static func userDefaults(_ userDefaults: UserDefaults = UserDefaults.standard) -> SMStorage<Key> where Key == String {
        return SMStorage<Key>(type: .userDefaults, userDefaults: userDefaults)
    }
    
    static func memory(initialValue: [Key: Any] = [:]) -> SMStorage<Key> where Key == String {
        return SMStorage<Key>(type: .memory, memory: initialValue)
    }
    
    static func files(inRootPath rootPath: URL) -> SMStorage<Key> where Key == String {
        return SMStorage<Key>(type: .files, rootPath: rootPath)
    }
    
}
