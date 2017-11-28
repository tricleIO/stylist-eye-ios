//
//  CurrentOutfitCategoriesCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 17.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Current Outfit categories command.
 */
struct CurrentOutfitCategoriesCommand: NetworkExecutable {
  
    /// Outfit model.
    typealias Data = OutfitCategoryDTO
    
    /// Set RUL manager
    var urlManager: APIUrlManager
    
    init() {
        urlManager = .currentOutfitCategories
    }
}
