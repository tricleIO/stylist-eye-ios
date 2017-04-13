//
//  PaginationDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 13.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import ObjectMapper

/**
 This struct contains pagination info from paginted requests
 */
public struct PaginationDTO: Mappable {
  
  /// current page
  var page: Int?
  /// items requested
  var size: Int?
  /// items returned
  var count: Int?
  /// current offset
  var offset: Int?
  /// total items
  var total: Int?
  /// var total pages - calculated
  var totalPages: Int {
    guard let size = size, let total = total else {
      return 0
    }
    return Int(ceil(Double(total)/Double(size)))
  }
  
  
  public init?(map: Map) {
    
  }
  
  mutating public func mapping(map: Map) {
    page <- map["page"]
    size <- map["size"]
    count <- map["count"]
    offset <- map["offset"]
    total <- map["total"]
  }
  
}
