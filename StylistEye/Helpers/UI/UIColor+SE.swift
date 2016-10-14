//
//  UIColor+SE.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Define public var from UIColor to use Palette through app.
 */
public var Palette = UIColor()

/**
 Extension of UIColor.
 */
extension UIColor {

    /**
     Basic palette colors used in the app.
        - black
        - clear
        - white
     */
    internal enum BasicPaletteColors {
        /// Black color.
        case black
        /// Clear color
        case clear
        /// White color.
        case white
    }

    subscript(basic basic: BasicPaletteColors) -> UIColor {
        switch basic {
        case .black:
            return UIColor.black
        case .clear:
            return UIColor.clear
        case .white:
            return UIColor.white
        }
    }

    /**
     Custom palette colors used in the app.
     - app color
     */
    internal enum CustomPaletteColors {
        /// App color.
        case appColor
        /// Purple
        case purple
    }

    subscript(custom custom: CustomPaletteColors) -> UIColor {
        switch custom {
        case .appColor:
            return UIColor(rgba: 0x94776d)
        case .purple:
            return UIColor(rgba: 0x41223e)
        }
    }

    public convenience init(rgba: UInt32) {
        self.init(
            red: CGFloat((rgba & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgba & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgba & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
