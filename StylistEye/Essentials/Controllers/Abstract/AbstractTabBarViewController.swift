//
//  AbstractTabBarViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Abstract tab bar controller setup initializable protocol for life-cycle methods.
 */
class AbstractTabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Load data from API every time.
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Just added elements to view and apply constraints.
        addElementsAndApplyConstraints()
    }
}
