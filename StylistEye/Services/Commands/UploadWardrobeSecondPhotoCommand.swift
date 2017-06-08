//
//  UploadWardrobeSecondPhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Uplad wardrobe command.
 */
struct UploadWardrobeSecondPhotoCommand: NetworkExecutable, UploadQueueItem {
  
  /// Outfit model.
  typealias Data = EmptyDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int, photo: Foundation.Data) {
    urlManager = .uploadWardrobeSecondPhoto(id: id, photo: photo)
  }
  
  func executeQueueItem(handler: @escaping ((Bool) -> Void)) {
    return self.executeCommand(completion: {
      data in
      switch data {
      case .success:
        handler(true)
      case .failure:
        handler(false)
      }
    })
  }
}
