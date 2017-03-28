//
//  DressStyleCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.03.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Garment type command.
 */
struct DressStyleTypeCommand: NetworkExecutable {
  
  typealias Data = DressStyleDTO
  
  var urlManager: APIUrlManager
  
  init() {
    urlManager = .dressStyle
  }
}
