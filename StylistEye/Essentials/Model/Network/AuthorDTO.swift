//
//  AuthorDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 07.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct AuthorDTO: Mappable {
    
    var identifier: Int
    var givenName: String?
    var familyName: String?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let identifier = id else {
            return nil
        }
        self.identifier = identifier
    }

    mutating func mapping(map: Map) {
        givenName <- map["givenName"]
        familyName <- map["familyName"]
    }
}
