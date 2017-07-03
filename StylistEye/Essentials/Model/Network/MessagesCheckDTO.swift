//
//  MessagesCheckDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 03.07.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import ObjectMapper

struct MessagesCheckDTO: Mappable {
  
  var unread: Int?
  var read: Int?
  var total: Int?
  var latest: Date?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    unread <- map["unread"]
    read <- map["read"]
    total <- map["total"]
    latest <- (map["timestamp"], DateTimeTransform(.iso8601Date))
  }
}
