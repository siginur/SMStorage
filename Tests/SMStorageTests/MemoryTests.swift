//
//  MemoryTests.swift
//  
//
//  Created by Alexey Siginur on 01/02/2022.
//

import XCTest
import SMStorage

class MemoryTests: XCTestCase {
    
    func testString() throws {
        let storage = SMStorage.memory()
        
        storage["int"] = intValue
        storage["string"] = stringValue
        storage["double"] = doubleValue
        storage["bool"] = boolValue
        storage["data"] = dataValue
        
        XCTAssertEqual(intValue, storage["int"])
        XCTAssertEqual(stringValue, storage["string"])
        XCTAssertEqual(doubleValue, storage["double"])
        XCTAssertEqual(boolValue, storage["bool"])
        XCTAssertEqual(dataValue, storage["data"])
    }
    
    func testInt() throws {
        let storage = SMStorage<Int>.memory()
        
        storage[1] = intValue
        storage[2] = stringValue
        storage[3] = doubleValue
        storage[4] = boolValue
        storage[5] = dataValue
        
        XCTAssertEqual(intValue, storage[1])
        XCTAssertEqual(stringValue, storage[2])
        XCTAssertEqual(doubleValue, storage[3])
        XCTAssertEqual(boolValue, storage[4])
        XCTAssertEqual(dataValue, storage[5])
    }
    
    func testEnum() throws {
        enum Key: String, StorageKey {
            case int
            case string
            case double
            case bool
            case dataValue
            var key: String { rawValue }
        }
        let storage = SMStorage<Key>.memory()
        
        storage[.int] = intValue
        storage[.string] = stringValue
        storage[.double] = doubleValue
        storage[.bool] = boolValue
        storage[.dataValue] = dataValue
        
        XCTAssertEqual(intValue, storage[.int])
        XCTAssertEqual(stringValue, storage[.string])
        XCTAssertEqual(doubleValue, storage[.double])
        XCTAssertEqual(boolValue, storage[.bool])
        XCTAssertEqual(dataValue, storage[.dataValue])
    }

}
