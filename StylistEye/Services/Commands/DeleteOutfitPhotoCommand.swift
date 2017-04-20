//
//  DeleteOutfitPhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 18.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Uplad wardrobe command.
 */
struct DeleteOutfitPhotoCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int) {
    urlManager = .deleteOutfitPhoto(id: id)
  }
}
