//
//  Serializable.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

protocol Serializable {

    init?(dictionary: [String: Any]?)
    func encode() -> [String: Any]
}

protocol StaticSerializable: Serializable {

    static var serializableKey: UserDefaults.UserDefaultsKeys { get }
}

extension Serializable {

    static func clear(_ serializableKey: String) {
        Defaults[serializableKey] = nil
    }

    static func clear(_ serializableKey: UserDefaults.UserDefaultsKeys) {
        Defaults[serializableKey] = nil
    }

    static func load(_ serializableKey: String) -> Self? {
        return Self(dictionary: Defaults[serializableKey].object as? [String: Any])
    }

    static func load(_ serializableKey: UserDefaults.UserDefaultsKeys) -> Self? {
        return Self(dictionary: Defaults[serializableKey].object as? [String: Any])
    }

    func save(_ serializableKey: String) {
        Defaults[serializableKey] = encode()
    }

    func save(_ serializableKey: UserDefaults.UserDefaultsKeys) {
        Defaults[serializableKey] = encode()
    }
}

extension StaticSerializable {

    static func clear() {
        clear(serializableKey)
    }

    static func load() -> Self? {
        return load(serializableKey)
    }

    func save() {
        save(Self.serializableKey)
    }
}
