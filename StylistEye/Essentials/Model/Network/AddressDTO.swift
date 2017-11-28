//
//  AddressDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 14.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct AddressDTO: Mappable {
    
    var street: String?
    var city: String?
    var state: String?
    var country: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        street <- map["street"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
    }
}
