//
//  WardrobeItemCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 04.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Wardrobe command.
 */
struct WardrobeItemCommand: NetworkExecutable {
  
  /// Outfit detail DTO
  typealias Data = WardrobeDTO
  
  /// Url manager.
  var urlManager: APIUrlManager
  
  init(id: Int) {
    urlManager = .wardrobeItem(id: id)
  }
}
