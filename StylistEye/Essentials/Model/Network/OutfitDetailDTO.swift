//
//  OutfitDetailDTOP.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct OutfitDetailDTO: Mappable {

    var pictureUrl: String?
    var pictureText: String?
    var garmentTypeId: Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        pictureUrl <- map["PictureUrl"]
        pictureText <- map["PictureText"]
        garmentTypeId <- map["GarmentTypeId"]
    }
}
