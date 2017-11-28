//
//  PhotosDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 14.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct PhotosDTO: Mappable {
    
    var image: String?
    var id: Int?
    var type: PhotoType?
  
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        image <- map["src"]
        id <- map["id"]
        type <- map["type"]
    }
}
