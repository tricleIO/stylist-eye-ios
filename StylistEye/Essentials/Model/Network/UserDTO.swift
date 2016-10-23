//
//  UserDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

/**
 This struct contains all information about user include token.
 */
struct UserDTO: Mappable {

    var firstname: String?
    var surname: String?
    var email: String?
    var token: String?
    var clientId: Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        firstname <- map["FirstName"]
        email <- map["Email"]
        surname <- map["Surname"]
        token <- map["Token"]
        clientId <- map["ClientId"]
    }
}
