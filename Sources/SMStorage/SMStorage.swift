//
//  SMStorage.swift
//
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

open class SMStorage<Key: StorageKey> {
    
    private let unarchiveClasses = [NSNumber.self, NSString.self, NSData.self, NSDate.self, NSArray.self, NSDictionary.self]
    
    private let dataPolicy: DataPolicy
    private let userDefaults: UserDefaults!
    private var memory: [Key: Any]!
    private let rootPath: URL?
    private let fileManager = FileManager.default
    public let type: Type
    
    // MARK: - Initializers
    
    private init() {
        self.type = .unknown
        self.userDefaults = nil
        self.memory = nil
        self.rootPath = nil
        self.dataPolicy = .rawData
    }
    
    private init(type: Type, userDefaults: UserDefaults? = nil, memory: [Key : Any]? = nil, rootPath: URL? = nil, dataPolicy: DataPolicy = .rawData) {
        self.type = type
        self.userDefaults = userDefaults
        self.memory = memory
        self.rootPath = rootPath
        self.dataPolicy = dataPolicy
    }
    
    @available(*, deprecated, renamed: "userDefaults(_:)", message: "Use static method for initialization")
    public init(userDefaults: UserDefaults) {
        self.type = .userDefaults
        self.userDefaults = userDefaults
        self.memory = nil
        self.rootPath = nil
        self.dataPolicy = .rawData
    }
    
    @available(*, deprecated, renamed: "memory(initialValue:)", message: "Use static method for initialization")
    public init(memoryInitial: [Key: Any]) {
        self.type = .memory
        self.userDefaults = nil
        self.memory = memoryInitial
        self.rootPath = nil
        self.dataPolicy = .rawData
    }
    
    public static func userDefaults(_ userDefaults: UserDefaults = UserDefaults.standard) -> SMStorage<Key> {
        return SMStorage<Key>(type: .userDefaults, userDefaults: userDefaults)
    }
    
    public static func memory(initialValue: [Key: Any] = [:]) -> SMStorage<Key> {
        return SMStorage<Key>(type: .memory, memory: initialValue)
    }
    
    public static func files(inRootPath rootPath: URL, dataPolicy: DataPolicy = .rawData) -> SMStorage<Key> {
        return SMStorage<Key>(type: .files, rootPath: rootPath, dataPolicy: dataPolicy)
    }
    
    public static func files(dataPolicy: DataPolicy = .rawData) -> SMStorage<Key> where Key.KeyType == URL {
        return SMStorage<Key>(type: .files, rootPath: nil, dataPolicy: dataPolicy)
    }
    
    public static func files(dataPolicy: DataPolicy = .rawData) -> SMStorage<Key> where Key == URL {
        return SMStorage<Key>(type: .files, rootPath: nil, dataPolicy: dataPolicy)
    }
    
    public static func keychain(dataPolicy: DataPolicy = .rawData) -> SMStorage<Key> {
        return SMStorage<Key>(type: .keychain, dataPolicy: dataPolicy)
    }

    // MARK: - Subscripts
    
    public final subscript(_ key: Key) -> String? { // workaround for files only
        get {
            return try? get(key)
        }
        set {
            guard let newValue = newValue else {
                remove(key)
                return
            }
            try? set(newValue, forKey: key)
        }
    }
    
    public final subscript(_ key: Key) -> Any? {
        get {
            return try? get(key)
        }
        set {
            guard let newValue = newValue else {
                remove(key)
                return
            }
            try? set(newValue, forKey: key)
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
    
    // MARK: - Getters
    
    public func get(_ key: Key) throws -> String? { // workaround for files only
        let value = try self.get(key) as Any?
        if dataPolicy == .rawData, let data = value as? Data {
            switch self.type {
            case .files, .keychain:
                return String(data: data, encoding: .utf8) ?? value as? String
            case .userDefaults, .memory, .unknown:
                return value as? String
            }
        }
        else {
            return value as? String
        }
    }
    
    public func get(_ key: Key) throws -> Any? {
        switch self.type {
        case .userDefaults:
            return userDefaults.object(forKey: key.key.description)
        case .memory:
            return memory[key]
        case .files:
            guard let url = fileUrl(withKey: key) else {
                throw Error.unableToBuildFileURL
            }
            let data = try Data(contentsOf: url)
            switch dataPolicy {
            case .wrapByNSKeyedArchiver:
                guard #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) else {
                    throw Error.unsupportedOSVersion
                }
                return try NSKeyedUnarchiver.unarchivedObject(ofClasses: unarchiveClasses, from: data)
            case .rawData:
                return data
            }
        case .keychain:
            guard let data = try KeychainAccess.get(byKey: key.key.description) as? Data else {
                throw Error.unexpectedValueType
            }
            switch dataPolicy {
            case .wrapByNSKeyedArchiver:
                guard #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) else {
                    throw Error.unsupportedOSVersion
                }
                return try NSKeyedUnarchiver.unarchivedObject(ofClasses: unarchiveClasses, from: data)
            case .rawData:
                return data
            }
        case .unknown:
            throw Error.unknownStorageType
        }
    }
    
    public final func get<Value>(_ key: Key) throws -> Value? {
        return try (get(key) as Any?) as? Value
    }
    
    // MARK: - Setters
    
    public func set(_ value: String, forKey key: Key) throws { // workaround for files only
        if dataPolicy == .rawData, let data = value.data(using: .utf8) {
            do {
                switch self.type {
                case .files, .keychain:
                    try set(data, forKey: key)
                case .userDefaults, .memory, .unknown:
                    try set(value as Any, forKey: key)
                }
            } catch {
                try set(value as Any, forKey: key)
            }
        }
        else {
            try set(value as Any, forKey: key)
        }
    }
    
    public func set(_ value: Any, forKey key: Key) throws {
        switch self.type {
        case .userDefaults:
            userDefaults.set(value, forKey: key.key.description)
        case .memory:
            memory[key] = value
        case .files:
            guard let url = fileUrl(withKey: key) else {
                throw Error.unableToBuildFileURL
            }
            switch dataPolicy {
            case .wrapByNSKeyedArchiver:
                guard #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) else {
                    throw Error.unsupportedOSVersion
                }
                let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
                try data.write(to: url)
            case .rawData:
                if let newValue = value as? Data {
                    try newValue.write(to: url)
                }
            }
        case .keychain:
            switch dataPolicy {
            case .wrapByNSKeyedArchiver:
                guard #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) else {
                    throw Error.unsupportedOSVersion
                }
                let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
                try KeychainAccess.set(data as CFTypeRef, forKey: key.key.description)
            case .rawData:
                if let data = value as? Data {
                    try KeychainAccess.set(data as CFTypeRef, forKey: key.key.description)
                }
            }
        case .unknown:
            throw Error.unknownStorageType
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
        case .keychain:
            try? KeychainAccess.delete(byKey: key.key.description)
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
        case .keychain:
            return KeychainAccess.contains(key: key.key.description)
        case .unknown:
            return false
        }
    }
    
    // MARK: - Help methods
    
    private func fileUrl(withKey key: Key) -> URL? {
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
    
    static func files(inRootPath rootPath: URL, dataPolicy: DataPolicy = .rawData) -> SMStorage<Key> where Key == String {
        return SMStorage<Key>(type: .files, rootPath: rootPath, dataPolicy: dataPolicy)
    }
    
    static func keychain(dataPolicy: DataPolicy = .rawData) -> SMStorage<Key> where Key == String {
        return SMStorage<Key>(type: .keychain, dataPolicy: dataPolicy)
    }
    
}
