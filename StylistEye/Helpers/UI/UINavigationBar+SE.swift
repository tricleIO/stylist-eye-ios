//
//  UINavigationBar+SE.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Navigation bar styles
 - black
 - white
 - solid with any status bar color
 - invisible with any status bar color
 */
enum NavigationBarStyle {
    case black
    case white
    case solid(withStatusBarColor: UIColor)
    case invisible(withStatusBarColor: UIColor)
}

extension UINavigationBar {

    // MARK: - Helpers
    /**
     Makes Navigation bar transparent and translucent.
     */
    func makeInvisibleBar() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = Palette[basic: .clear]
    }

    /**
     Makes Navigation Bar visible.
     - Parameter palette: The color to apply to the navigation bar background.
     */
    internal func sbBackgroundColor(color: UIColor) {
        guard  let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else {
            return
        }
        statusBar.backgroundColor = color
    }

    /**
     Apply style on navigation bar.
     - white
     - black
     - solid
     - invisible
     */
    func applyStyle(style: NavigationBarStyle) {
        isTranslucent = false
        switch style {
        case .white:
            sbBackgroundColor(color: Palette[basic: .white])
            barStyle = .default
            barTintColor = Palette[basic: .white]
            tintColor = Palette[basic: .black]
        case .black:
            sbBackgroundColor(color: Palette[basic: .black])
            barTintColor = Palette[basic: .black]
            barStyle = .black
            tintColor = Palette[basic: .white]
        case let .solid(color):
            sbBackgroundColor(color: color)
            barTintColor = color
            barStyle = .black
        case let .invisible(color):
            sbBackgroundColor(color: color)
            makeInvisibleBar()
            barStyle = .blackOpaque
        }
    }
}
