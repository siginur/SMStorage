//
//  StorageType.swift
//  
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

public extension SMStorage {
    
    enum `Type` {
        /// Only for internal use
        case unknown
        
        /// Dictionary stored in memory
        case memory
        
        /// UserDefaults instance
        case userDefaults
        
        /// Files stored on disk
        case files
        
        /// Data stored in system keychain
        case keychain
    }
    
    enum DataPolicy {
        /// Save/Load values as is
        case rawData
        
        /// Archive values by `NSKeyedArchiver` before save and unarchive result by `NSKeyedUnarchiver` before returning value to the caller
        @available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *)
        case wrapByNSKeyedArchiver
    }
    
    enum Error: Swift.Error {
        case unknownStorageType
        case unsupportedOSVersion
        case unableToBuildFileURL
        case unexpectedValueType
    }
    
}
