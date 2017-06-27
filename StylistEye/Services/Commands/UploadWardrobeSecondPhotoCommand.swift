//
//  UploadWardrobeSecondPhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

/**
 Uplad wardrobe command.
 */
struct UploadWardrobeSecondPhotoCommand: NetworkExecutable, UploadQueueItem {
  
  /// Outfit model.
  typealias Data = UploadPhotoResponseDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  var image: UIImage
  
  var imageData: Foundation.Data
  
  init(id: Int, image: UIImage, imageData: Foundation.Data) {
    urlManager = .uploadWardrobeSecondPhoto(id: id, photo: imageData)
    self.image = image
    self.imageData = imageData
  }
  
  func executeQueueItem(handler: @escaping ((Bool, UploadPhotoResponseDTO?) -> Void)) {
    self.executeCommand(completion: {
      data in
      switch data {
      case let .success(data, objectsArray: _, pagination: _, apiResponse: _):
        handler(true, data)
      case .failure:
        handler(false, nil)
      }
    })
  }
  
}
