//
//  GarmentTypeDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 19.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct GarmentTypeDTO: Mappable {

    var typeId: Int?
    var languageId: Languages?
    var name: String?
    var icon: String?

    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let gID = id else {
            return nil
        }
        typeId = gID
    }

    mutating func mapping(map: Map) {
        languageId <- (map["language"], EnumTransform<Languages>())
        name <- map["name"]
        icon <- map["icon"]
    }
}
