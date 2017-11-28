//
//  ComponentsDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 14.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct ComponentsDTO: Mappable {
    
    var componentsId: Int?
    var garmetType: GarmentTypeDTO?
    var photo: PhotosDTO?
    var source: Int?
    var componentType: Int?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let cId = id else {
            return nil
        }
        componentsId = cId
    }
    
    mutating func mapping(map: Map) {
        garmetType <- map["garmetType"]
        photo <- map["photo"]
        source <- map["source"]
        componentType <- map["componentType"]
    }
}
