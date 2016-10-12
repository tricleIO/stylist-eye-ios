//
//  AccessToken.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

struct AccessToken {

    var valid: Bool {
        return value != nil
    }

    fileprivate (set) var value: String? {
        get {
            guard let value = Keychains[.accessTokenKey] else {
                return nil
            }
            return value
        }
        set {
            if let newValue = newValue {
                Keychains[.accessTokenKey] = newValue
            }
            else {
                Keychains[.accessTokenKey] = nil
            }
        }
    }

    init?() {
        if value == nil {
            return nil
        }
    }

    init?(token: String?) {
        if let token = token {
            value = token
        }
        return nil
    }

    mutating func clean() {
        value = nil
    }
}
