//
//  OutfitsDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct OutfitsDTO: Mappable {

    var outfitId: Int
    var dressStyle: Int?
    var photos: [PhotosDTO]?
    var outfitComment: String?
    var stylist: StylistDTO?
    var address: AddressDTO?
    var components: [ComponentsDTO]?
    var isFavourite: Bool?

    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let oID = id else {
            return nil
        }
        outfitId = oID
    }

    mutating func mapping(map: Map) {
        outfitId <- map["id"]
        stylist <- map["stylist"]
        dressStyle <- map["dressStyle"]
        outfitComment <- map["comment"]
        photos <- map["photos"]
        address <- map["address"]
        components <- map["components"]
        isFavourite <- map["isFavourite"]
    }
}

