//
//  CurrentOutfitDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import ObjectMapper

struct CurrentOutfitDTO: Mappable {
  
  var outfitId: Int?
  var category: GarmentTypeDTO?
  var photo: PhotosDTO?
  
  init?(map: Map) {
    var id: Int?
    id <- map["id"]
    guard let oId = id else {
      return nil
    }
    outfitId = oId
  }
  
  mutating func mapping(map: Map) {
    category <- map["currentCategory"]
    photo <- map["photo"]
  }
}

