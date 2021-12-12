//
//  StorageType.swift
//  
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

public enum StorageType {
    /// Only for internal use
    case unknown
    
    /// Dictionary stored in memory
    case memory
    
    /// UserDefaults instance
    case userDefaults
}
