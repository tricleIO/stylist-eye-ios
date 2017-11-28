//
//  StylistCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 16.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Stylist list command.
 */
struct StylistCommand: NetworkExecutable {
    
    /// Stylist list DTO.
    typealias Data = StylistListDTO
    
    /// Url manager.
    var urlManager: APIUrlManager
    
    init() {
        urlManager = .stylistList
    }
}
