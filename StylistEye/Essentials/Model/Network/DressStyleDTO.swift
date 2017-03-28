//
//  DressStyleDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.03.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import ObjectMapper

struct DressStyleDTO: Mappable {
  
  var styleId: String?
  var languageId: Languages = .unknown
  var name: String?
  
  init?(map: Map) {
    var id: Int?
    id <- map["id"]
    guard let gID = id else {
      return nil
    }
    styleId = String(gID)
  }
  
  mutating func mapping(map: Map) {
    languageId <- (map["language"], EnumTransform<Languages>())
    name <- map["name"]
  }
}
