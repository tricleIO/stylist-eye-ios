//
//  OutfitDetailDTOP.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct OutfitDetailDTO: Mappable {

    var outfitId: Int?
    var isFavourite: String?
    var dressStyle: OutfitCategoryDTO?
    var photos: [PhotosDTO] = []
    var components: [ComponentsDTO] = []
    var stylist: StylistDTO?
    var comment: String?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let oId = id else {
            return nil
        }
        outfitId = oId
    }

    mutating func mapping(map: Map) {
        isFavourite <- map["isFavourite"]
        dressStyle <- map["dressStyle"]
        photos <- map["photos"]
        components <- map["components"]
        stylist <- map["stylist"]
        comment <- map["comment"]
    }
}
