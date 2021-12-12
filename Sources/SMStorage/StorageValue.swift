//
//  StorageValue.swift
//  
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

public struct StorageValue {
    private let value: Any?
    
    public var any: Any? {
        value
    }
    
    // MARK: Int

    public var int: Int? {
        value as? Int
    }
    public var int8: Int8? {
        value as? Int8
    }
    public var int16: Int16? {
        value as? Int16
    }
    public var int32: Int32? {
        value as? Int32
    }
    public var int64: Int64? {
        value as? Int64
    }

    // MARK: UInt
    
    public var uint: UInt? {
        value as? UInt
    }
    public var uint8: UInt8? {
        value as? UInt8
    }
    public var uint16: UInt16? {
        value as? UInt16
    }
    public var uint32: UInt32? {
        value as? UInt32
    }
    public var uint64: UInt64? {
        value as? UInt64
    }
    
    // MARK: Decimal

    public var double: Double? {
        value as? Double
    }
    public var float: Float? {
        value as? Float
    }

    // MARK: Collections

    public var array: Array<Any>? {
        value as? Array<Any>
    }
    public var dictionary: Dictionary<AnyHashable, Any>? {
        value as? Dictionary<AnyHashable, Any>
    }
    public var set: Set<AnyHashable>? {
        value as? Set<AnyHashable>
    }
    
    // MARK: Other

    public var date: Date? {
        value as? Date
    }
    public var data: Data? {
        value as? Data
    }
    public var string: String? {
        value as? String
    }
    public var bool: Bool? {
        value as? Bool
    }
    
    // MARK: Generic methods

    public func dictionary<Key: Hashable, Value>(_ key: Key.Type, _ value: Value.Type) -> Dictionary<Key, Value>? {
        return self.value as? Dictionary<Key, Value>
    }
    
    public func array<Value>(_ value: Value.Type) -> Array<Value>? {
        return self.value as? Array<Value>
    }
    
    public func set<Value: Hashable>(_ value: Value.Type) -> Set<Value>? {
        return self.value as? Set<Value>
    }
    
    // MARK: Init
    
    init(_ value: Any?) {
        self.value = value
    }
    
}
