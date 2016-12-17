//
//  StylistListDTOP.swift
//  StylistEye
//
//  Created by Michal Severín on 16.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct StylistListDTO: Mappable {
    
    var stylistId: String?
    var givenName: String?
    var familyName: String?
    var photo: PhotosDTO?
    var rating: Int?
    var address: AddressDTO?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let sId = id else {
            return nil
        }
        stylistId = String(sId)
    }
    
    mutating func mapping(map: Map) {
        givenName <- map["givenName"]
        familyName <- map["familyName"]
        photo <- map["photo"]
        rating <- map["rating"]
        address <- map["address"]
    }
}
