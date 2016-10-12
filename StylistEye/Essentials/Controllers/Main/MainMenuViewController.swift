//
//  MainMenuViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class MainMenuViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > public
    var userInfo: UserInfo?

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()
    }

    internal override func customInit() {
        super.customInit()

        userInfo = UserInfo.load()
    }
}
