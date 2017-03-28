//
//  GarmentType.swift
//  StylistEye
//
//  Created by Michal Severín on 09.01.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

/**
 Garment type command.
 */
struct GarmentTypeCommand: NetworkExecutable {
    
    typealias Data = GarmentTypeDTO
    
    var urlManager: APIUrlManager
    
    init() {
        urlManager = .garmentType
    }
}
