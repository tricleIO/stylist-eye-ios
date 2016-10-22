//
//  UIFont.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/// Public propertie for UIFont.
public var SystemFont = UIFont()

/**
 This extension contains all used applications fonts.
 */
extension UIFont {

    // MARK: Enum definition
    internal enum Fonts {
        case title
        case description
        case litleDescription
    }

    subscript(font: Fonts) -> UIFont {
        var fontForUse: UIFont?
        switch font {
        case .title:
            fontForUse = UIFont(name: "Avenir", size: 20)
        case .description:
            fontForUse = UIFont(name: "Avenir", size: 16)
        case .litleDescription:
            fontForUse = UIFont(name: "Avenir", size: 12)
        }
        guard let fontToReturn = fontForUse else {
            return UIFont.systemFont(ofSize: 10)
        }
        return fontToReturn
    }
}
