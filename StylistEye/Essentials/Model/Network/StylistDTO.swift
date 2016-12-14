//
//  StylistDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 14.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct StylistDTO: Mappable {
    
    var stylistId: Int?
    var givenName: String?
    var familyName: String?
    var photo: PhotosDTO?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let sId = id else {
            return nil
        }
        stylistId = sId
    }
    
    mutating func mapping(map: Map) {
        givenName <- map["givenName"]
        familyName <- map["familyName"]
        photo <- map["photo"]
    }
}
