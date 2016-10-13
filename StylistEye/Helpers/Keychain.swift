//
//  Keychai.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation
import Security

/**
 Public propertie Keychain that include all keychain keys.
 */
import Foundation
import Security

public let Keychains = Keychain()
open class Keychain {

    subscript(key: String) -> String? {
        get {
            return load(key: key)
        }
        set {
            if let value = newValue {
                save(key: key, value: value)
            }
            else {
                delete(key)
            }
        }
    }

    @discardableResult
    func clear() -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            ]

        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return status == noErr
    }

    @discardableResult
    fileprivate func save(key: String, value: String) -> Bool {
        guard let data: Data = value.data(using: String.Encoding.utf8) else {
            return false
        }
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        return status == noErr
    }

    fileprivate func load(key aKey: String) -> String? {
        let keyChainQuery = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: aKey,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            ] as [String : Any]
        var extractedData: AnyObject?

        let status: OSStatus = SecItemCopyMatching(keyChainQuery as CFDictionary, &extractedData)
        if status == noErr {
            if let retrievedData = extractedData as? Data {
                return String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        }
        return nil
    }

    @discardableResult
    fileprivate func delete(_ key: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            ] as [String : Any]

        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return status == noErr
    }

    // MARK: - KeyChainKeys Wrapper
    subscript(keyEnum: KeychainKeys) -> String? {
        get {
            return self[keyEnum.key]
        }
        set {
            self[keyEnum.key] = newValue
        }
    }
}
