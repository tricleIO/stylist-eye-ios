//
//  CurrentOutfitsCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.06.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Current Outfits command.
 */
struct CurrentOutfitsCommand: NetworkExecutable {
  
  /// Outfit model.
  typealias Data = OutfitsDTO
  
  /// Set RUL manager
  var urlManager: APIUrlManager
  
  init() {
    urlManager = .currentOutfits
  }
}
