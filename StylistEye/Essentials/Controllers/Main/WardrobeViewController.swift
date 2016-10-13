//
//  WardrobeViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class WardrobeViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > public
    
    
    // MARK: > private
    fileprivate let backgroundImageView = ImageView()
    
    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()
        
        backgroundImageView.image = #imageLiteral(resourceName: "whiteBg_image")
        
        print(Keychains[.accessTokenKey])
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                backgroundImageView,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    internal override func setupView() {
        super.setupView()
        
        title = StringContainer[.wardrobe]
        view.backgroundColor = Palette[basic: .white]
    }
}
