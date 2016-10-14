//
//  KeychainKeys.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

/**
 Keychain protocol.
 */
protocol KeychainKeysProtocol {
    var key: String {get}
}

extension KeychainKeysProtocol where Self:RawRepresentable, Self.RawValue == String {
    var key: String {
        return "\(rawValue)"
    }
}

/**
 Keychain keys coantins all keychain keys.
    - accessTokenKey
 */
public enum KeychainKeys: String, KeychainKeysProtocol {
    
    /// Access token key.
    case accessTokenKey = "SlevomatAccessTokenKey56y3yiye7865"
}
