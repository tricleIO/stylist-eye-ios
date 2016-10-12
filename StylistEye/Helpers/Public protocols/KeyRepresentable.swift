//
//  KeyRepresentable.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

protocol KeyRepresentable {

    var key: String { get }
}

protocol ValueRepresentable {

    var value: String? { get }
}

protocol KeyValueRepresentable: KeyRepresentable, ValueRepresentable {

}

extension KeyRepresentable where Self: RawRepresentable, Self.RawValue == String {

    var key: String {
        return rawValue
    }
}
