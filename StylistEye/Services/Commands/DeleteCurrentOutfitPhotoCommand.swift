//
//  DeleteCurrentOutfitPhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 05.07.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Delete current outfit photo command.
 */

struct DeleteCurrentOutfitPhotoCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int) {
    urlManager = .deleteCurrentOutfitPhoto(id: id)
  }
}
