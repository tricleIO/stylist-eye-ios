//
//  Configuration.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit
import Foundation

/**
 API Configuration.
 */
struct APIConfiguration {

    /// Basic API url.
    static let BaseUrl = "https://stylisteye.com" // http://stylist.azurewebsites.net
}

/**
 GUI Configuration.
 */
struct GUIConfiguration {

    /// Height for message cell.
    static let MessageCellHeight: CGFloat = 80.0
    /// Height for default cell.
    static let CellHeight: CGFloat = 65.0
    /// Height for outfit cell.
    static let OutfitCellHeight: CGFloat = 700.0
    /// Default animation duration.
    static let DefaultAnimationDuration: Double = 0.3
}
