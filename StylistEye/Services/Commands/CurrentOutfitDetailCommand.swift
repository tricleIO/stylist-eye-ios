//
//  CurrentOutfitDetailCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Current Outfit categories command.
 */
struct CurrentOutfitDetailCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = OutfitDetailDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init(id: Int) {
    urlManager = .currentOutfitDetail(id: id)
  }
}
