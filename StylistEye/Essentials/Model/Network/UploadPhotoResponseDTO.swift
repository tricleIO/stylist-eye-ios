//
//  UploadPhotoResponseDTO.swift
//  StylistEye
//
//  Created by Martin Stachon on 27.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import ObjectMapper

struct UploadPhotoResponseDTO: Mappable {
  
  var id: Int
  var photo: PhotosDTO?
  
  init?(map: Map) {
    var id: Int?
    id <- map["id"]
    guard let oID = id else {
      return nil
    }
    self.id = oID
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    photo <- map["photo"]
  }
}
