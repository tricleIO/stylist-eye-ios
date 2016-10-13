//
//  MainMenuViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class MainMenuViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > public
    var userInfo: UserInfo?
    
    // MARK: > private
    private let welcome = UILabel()

    // MARK: - <Initializable>
    internal override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[basic: .white]
    }
    
    internal override func initializeElements() {
        super.initializeElements()
    }

    internal override func customInit() {
        super.customInit()

        userInfo = UserInfo.load()
        
        welcome.text = userInfo?.firstname
        
        view.addSubview(welcome)
        
        welcome.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.center.equalTo(view)
        }
    }
}
