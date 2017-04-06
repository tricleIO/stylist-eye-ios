//
//  UploadOutfitPhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 06.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Uplad wardrobe command.
 */
struct UploadOutfitPhotoCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int, photoType: PhotoType, photo: Foundation.Data) {
    urlManager = .uploadOutfitPhoto(id: id, photoType: photoType.rawValue, photo: photo)
  }
}
