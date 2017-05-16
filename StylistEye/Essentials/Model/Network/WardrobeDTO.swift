//
//  WardrobeDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 04.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import ObjectMapper

struct WardrobeDTO: Mappable {
  
  var wardrobeId: Int
  var photos: [PhotosDTO]?
  var garmetType: GarmentTypeDTO?
  var isFavourite: Bool?
  var reviews: [ReviewDTO]?
  
  init?(map: Map) {
    var id: Int?
    id <- map["id"]
    guard let oID = id else {
      return nil
    }
    wardrobeId = oID
  }
  
  mutating func mapping(map: Map) {
    wardrobeId <- map["id"]
    garmetType <- map["garmetType"]
    photos <- map["photos"]
    isFavourite <- map["isFavourite"]
    reviews <- map["reviews"]
  }
}
