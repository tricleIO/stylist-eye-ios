//
//  UIView+SE.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

extension UIView: InitializableProtocol {

    /**
     Add views as subview to view.
     - Parameter views: represents all views
     - Example view.addSubviews([label, button])
     */
    func addSubviews(views: [UIView]) {
        views.forEach { element in
            addSubview(element)
        }
    }

    // MARK: - <Initializable>
    func addElements() {}
    func customInit() {}
    func initializeElements() {}
    func setupConstraints() {}
    func loadData() {}
    func setupView() {}
    func setupBackgroundImage() {}
}
