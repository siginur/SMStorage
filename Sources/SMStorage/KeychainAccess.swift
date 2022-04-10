//
//  KeychainAccess.swift
//
//
//  Created by Alexey Siginur on 08/08/2020.
//

import Foundation

class KeychainAccess {
    
    static func set(_ data: CFTypeRef, forKey key: String) throws {
        var resultCode: OSStatus
        if contains(key: key) {
            let querySearch: [CFString: AnyObject] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key as AnyObject,
                kSecReturnData: kCFBooleanFalse,
                kSecReturnAttributes: kCFBooleanTrue,
                kSecMatchLimit: kSecMatchLimitOne
            ]
            var attributes: CFTypeRef?
            resultCode = withUnsafeMutablePointer(to: &attributes) {
                SecItemCopyMatching(querySearch as CFDictionary, UnsafeMutablePointer($0))
            }
            if let error = resultCode.error {
                throw error
            }

            var queryUpdate = attributes as? Dictionary<CFString, CFTypeRef> ?? [:]
            queryUpdate[kSecClass] = kSecClassGenericPassword
            let updatedAttributes: [String: AnyObject] = [
                kSecAttrAccount as String: key as AnyObject,
                kSecValueData as String: data as AnyObject,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            resultCode = SecItemUpdate(queryUpdate as CFDictionary, updatedAttributes as CFDictionary)
        }
        else {
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key as AnyObject,
                kSecValueData as String: data as AnyObject,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            resultCode = SecItemAdd(query as CFDictionary, nil)
        }
        
        if let error = resultCode.error {
            throw error
        }
    }
    
    static func delete(byKey key: String) throws {
        guard contains(key: key) == true else {
            return
        }
        
        let queryDelete: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key as AnyObject
        ]
        
        let resultCode = SecItemDelete(queryDelete as CFDictionary)
        
        if let error = resultCode.error {
            throw error
        }
    }
    
    static func get(byKey key: String) throws -> CFTypeRef? {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: CFTypeRef?
        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if let error = resultCode.error {
            throw error
        }
        return result
    }
    
    static func contains(key: String) -> Bool {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key as AnyObject,
            kSecReturnData as String: kCFBooleanFalse,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        let resultCodeLoad = SecItemCopyMatching(queryLoad as CFDictionary, nil)
        return resultCodeLoad != errSecItemNotFound
    }
}

fileprivate extension OSStatus {
    var error: NSError? {
        guard self != errSecSuccess else { return nil }
        
        let message: String
        if #available(iOS 11.3, *) {
            message = SecCopyErrorMessageString(self, nil) as String? ?? "Unknown error"
        } else {
            message = "No error description"
        }
        
        return NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: [
            NSLocalizedDescriptionKey: message])
    }
}
