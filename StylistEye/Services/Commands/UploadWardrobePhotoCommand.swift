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
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int, photo: Foundation.Data) {
    urlManager = .uploadWardrobePhoto(id: id, photo: photo)
  }
}
