//
//  DeleteWardrobePhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Uplad wardrobe command.
 */
struct DeleteWardrobePhotoCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int) {
    urlManager = .deleteWardrobePhoto(id: id)
  }
}
