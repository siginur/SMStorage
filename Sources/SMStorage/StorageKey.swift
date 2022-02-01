//
//  StorageKey.swift
//  
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

public protocol StorageKey: Hashable {
    associatedtype KeyType: CustomStringConvertible
    var key: KeyType { get }
}

extension String: StorageKey {
    public var key: String { self }
}

extension Int: StorageKey {
    public var key: String { "\(self)" }
}

extension URL: StorageKey {
    public var key: String { "\(self.path)" }
}
