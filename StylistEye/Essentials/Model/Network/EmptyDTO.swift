//
//  EmptyDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

/**
 This struct is for responses without data for any model.
 */
struct EmptyDTO: Mappable {

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
    }
}
