//
//  OutfitCategoryCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 17.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Outfit category command.
 */
struct OutfitCategoryCommand: NetworkExecutable {
  
    /// Outfit model.
    typealias Data = OutfitCategoryDTO
    
    /// Set RUL manager
    var urlManager: APIUrlManager
    
    init() {
        urlManager = .outfitCategory
    }
}
