//
//  Optional.swift
//  StylistEye
//
//  Created by Michal Severín on 21.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

protocol DefaultInit {

    init()
}

extension String: DefaultInit {

}

extension Int: DefaultInit {

}

extension Optional where Wrapped: DefaultInit {

    var forcedValue: Wrapped {
        switch self {
        case let .some(value):
            return value
        case .none:
            return Wrapped()
        }
    }
}
