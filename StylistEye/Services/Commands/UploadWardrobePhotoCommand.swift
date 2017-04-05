//
//  UploadWardrobePhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 05.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Uplad wardrobe command.
 */
struct UploadWardrobePhotoCommand: NetworkExecutable {
  
  
  enum PhotoType: Int {
    case OutfitPhotoBase = 20
    case OtherOutfitPhoto = 21
  }
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int, photoType: PhotoType, photo: Foundation.Data) {
    urlManager = .uploadWardrobePhoto(id: id, photoType: photoType.rawValue, photo: photo)
  }
}
