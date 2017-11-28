//
//  DeleteWardrobePhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Delete wardrobe photo command.
 */
struct DeleteWardrobePhotoCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int, type: PhotoType) {
    urlManager = .deleteWardrobePhoto(id: id, type: type.rawValue)
  }
}
