//
//  StorageKey.swift
//  
//
//  Created by Alexey Siginur on 12/12/2021.
//

import Foundation

public protocol StorageKey {
    var key: String { get }
}

extension String: StorageKey {
    public var key: String { self }
}

extension Int: StorageKey {
    public var key: String { "\(self)" }
}
