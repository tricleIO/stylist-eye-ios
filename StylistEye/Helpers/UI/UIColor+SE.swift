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
        /// Gray color
        case gray
        /// White color.
        case white
    }

    subscript(basic basic: BasicPaletteColors) -> UIColor {
        switch basic {
        case .black:
            return UIColor.black
        case .clear:
            return UIColor.clear
        case .gray:
            return UIColor.gray
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
        /// Purple.
        case purple
        /// Title.
        case title
    }

    subscript(custom custom: CustomPaletteColors) -> UIColor {
        switch custom {
        case .appColor:
            return #colorLiteral(red: 0.712184608, green: 0.593695581, blue: 0.5477623343, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.2348051667, green: 0.1022515669, blue: 0.2371747196, alpha: 1)
        case .title:
            return #colorLiteral(red: 0.9141632318, green: 0.8006886244, blue: 0.5803021789, alpha: 1)
//        case .titleLight:
//            return #colorLiteral(red: 0.9141632318, green: 0.8006886244, blue: 0.5803021789, alpha: 1)
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
