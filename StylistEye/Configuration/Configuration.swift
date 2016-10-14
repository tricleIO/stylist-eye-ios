//
//  Configuration.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 API Configuration.
 */
struct APIConfiguration {

    /// Basic API url.
    static let BaseUrl = "http://stylist.azurewebsites.net"
}

/**
 GUI Configuration.
 */
struct GUIConfiguration {

    /// Height for message cell.
    static let MessageCellHeight = 100.0
    /// Height for default cell.
    static let CellHeight = 65.0
    /// Height for outfit cell.
    static let OutfitCellHeight = 350.0
    /// Default animation duration.
    static let DefaultAnimationDuration: Double = 0.3
}
