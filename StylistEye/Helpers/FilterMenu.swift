//
//  FilterMenu.swift
//  StylistEye
//
//  Created by Michal Severín on 23.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

protocol FilterProtocol {
    var cellName: String {get}
    var image: UIImage {get}
    var controller: UIViewController {get}
}

enum FilterMenu: FilterProtocol {
    
    case stylists
    case outfitsCategory
    
    static let allCases: [FilterMenu] = [
        .stylists,
        .outfitsCategory,
    ]
    
    // TODO: @MS
    var cellName: String {
        switch self {
        case .stylists:
          return StringContainer[.stylists]
        case .outfitsCategory:
          return StringContainer[.outfitsCategory]
        }
    }
    
    var image: UIImage {
        switch self {
        case .outfitsCategory:
            return #imageLiteral(resourceName: "panel")
        case .stylists:
            return #imageLiteral(resourceName: "profileImage")
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .outfitsCategory:
            fallthrough
        case .stylists:
            return UIViewController()
        }
    }
}
