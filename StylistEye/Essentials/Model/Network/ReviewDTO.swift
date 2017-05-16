//
//  ReviewDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 04.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReviewDTO: Mappable {
  
  var id: Int?
  var comment: String?
  var stylist: StylistDTO?
  var rating: Int?
  // TODO language
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    comment <- map["comment"]
    stylist <- map["stylist"]
    rating <- map["rating"]
  }
}
