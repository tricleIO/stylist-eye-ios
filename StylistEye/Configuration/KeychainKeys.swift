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
    - user email
    - user password
 */
public enum KeychainKeys: String, KeychainKeysProtocol {

    /// Access token key.
    case accessTokenKey = "StylistEyeAkcesToken009"
    /// User email.
    case userEmail = "StylistUZerEmal066"
    /// User password.
    case userPassword = "StylistPasvort123456"
}
