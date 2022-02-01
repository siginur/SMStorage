//
//  FilesTests.swift
//  
//
//  Created by Alexey Siginur on 01/02/2022.
//

import XCTest
import SMStorage

class FilesTests: XCTestCase {
    
    static let rootPath = FileManager.default.temporaryDirectory
    
    override class func setUp() {
        print("Root path:", rootPath)
    }
    
    func testString() throws {
        let storage = SMStorage.files(inRootPath: Self.rootPath)
        
        storage["data"] = dataValue
        
        XCTAssertEqual(dataValue, storage["data"])
    }
    
    func testInt() throws {
        let storage = SMStorage<Int>.files(inRootPath: Self.rootPath)
        
        storage[5] = dataValue
        
        XCTAssertEqual(dataValue, storage[5])
    }
    
    func testEnum() throws {
        enum Key: String, StorageKey {
            case dataValue
            var key: String { rawValue }
        }
        let storage = SMStorage<Key>.files(inRootPath: Self.rootPath)
        
        storage[.dataValue] = dataValue
        
        XCTAssertEqual(dataValue, storage[.dataValue])
    }
    
    func testEnumURL() throws {
        enum Key: StorageKey {
            case dataValue
            var key: URL { FilesTests.rootPath.appendingPathComponent("smstorage-enum") }
        }
        let storage = SMStorage<Key>.files()
        
        storage[.dataValue] = dataValue
        
        XCTAssertEqual(dataValue, storage[.dataValue])
    }
    
    func testURL() throws {
        let storage = SMStorage.files()
        
        let url = FilesTests.rootPath.appendingPathComponent("smstorage-path")
        storage[url] = dataValue
        
        XCTAssertEqual(dataValue, storage[url])
    }
    
}
