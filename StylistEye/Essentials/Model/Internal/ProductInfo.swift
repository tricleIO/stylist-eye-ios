//
//  ProductInfo.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

struct ProductInfo {

    var name: String
    var infoText: String

    // TODO: @MS - for ProductDTO
    init(name: String, infoText: String) {
        self.name = name
        self.infoText = infoText
    }
}
