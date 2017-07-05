//
//  UploadCurrentOutfitPhoto.swift
//  StylistEye
//
//  Created by Martin Stachon on 05.07.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

/**
 Uplad wardrobe command.
 */
struct UploadCurrentOutfitPhotoCommand: NetworkExecutable, UploadQueueItem {
  
  /// Outfit model.
  typealias Data = UploadCurrentOutfitPhotoResponseDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  var image: UIImage
  
  var imageData: Foundation.Data
  
  var type: UploadPhotoCategory {
    return .currentOutfits
  }
  
  var id: Int
  
  var uploadCategoryId: Int {
    return id
  }
  
  init(id: Int, image: UIImage, imageData: Foundation.Data) {
    urlManager = .uploadCurrentOutfitPhoto(id: id, photo: imageData)
    self.image = image
    self.imageData = imageData
    self.id = id
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
