//
//  OutfitCategoryDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 17.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct OutfitCategoryDTO: Mappable {
    
    var categoryId: Int?
    var languageId: Languages = .unknown
    var name: String?
    var icon: String?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let gID = id else {
            return nil
        }
        categoryId = gID
    }
    
    mutating func mapping(map: Map) {
        languageId <- (map["language"], EnumTransform<Languages>())
        name <- map["name"]
        icon <- map["icon"]
    }
}
