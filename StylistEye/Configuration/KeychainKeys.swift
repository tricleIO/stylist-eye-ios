//
//  KeychainKeys.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

protocol KeychainKeysProtocol {
    var key: String {get}
}

extension KeychainKeysProtocol where Self:RawRepresentable, Self.RawValue == String {
    var key: String {
        return "\(rawValue)"
    }
}

public enum KeychainKeys: String, KeychainKeysProtocol {
    case accessTokenKey = "SlevomatAccessTokenKey56y3yiye7865"
}
