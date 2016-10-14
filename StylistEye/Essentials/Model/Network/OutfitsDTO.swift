//
//  OutfitsDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct OutfitsDTO: Mappable {

    var outfitId: Int?
    var stylistId: Int?
    var outfitName: String?
    var dressStyle: Int?
    var outfitComment: String?
    var author: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        outfitId <- map["Id"]
        stylistId <- map["StylistId"]
        outfitName <- map["OutfitName"]
        dressStyle <- map["DressStyleId"]
        outfitComment <- map["OutfitComment"]
        author <- map["Author"]
    }
}
