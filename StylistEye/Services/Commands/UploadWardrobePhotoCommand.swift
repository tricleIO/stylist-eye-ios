//
//  UploadWardrobePhotoCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 05.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

/**
 Uplad wardrobe command.
 */
struct UploadWardrobePhotoCommand: NetworkExecutable, UploadQueueItem {
  
  /// Outfit model.
  typealias Data = UploadPhotoResponseDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  var image: UIImage
  
  var imageData: Foundation.Data
  
  var type: UploadPhotoCategory {
    return .wardrobe
  }
  
  var uploadCategoryId: Int {
    return id
  }
  
  var id: Int
  
  init(id: Int, image: UIImage, imageData: Foundation.Data) {
    self.id = id
    urlManager = .uploadWardrobePhoto(id: id, photo: imageData)
    self.image = image
    self.imageData = imageData
  }
  
  func executeQueueItem(handler: @escaping ((Bool, UploadPhotoResponse?) -> Void)) {
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
