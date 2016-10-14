//
//  Reusable.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

protocol Reusable {

    static var reuseIdentifier: String {get}
}

extension Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
