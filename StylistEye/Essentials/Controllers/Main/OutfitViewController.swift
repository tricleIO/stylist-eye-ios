//
//  OutfitViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class OutfitViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > public
    
    
    // MARK: > private
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(settingsButtonTapped))
    
    fileprivate let backgroundImageView = ImageView()
    
    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()
        
        backgroundImageView.image = #imageLiteral(resourceName: "whiteBg_image")
        
        navigationItem.leftBarButtonItem = leftBarButton
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

        title = StringContainer[.outfit]
        view.backgroundColor = Palette[basic: .white]
    }
    
    // MARK: - User Action
    func settingsButtonTapped() {
        openSettingsView()
    }
    
    // MARK: - Actions
    fileprivate func openSettingsView() {
        let navigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.navigationBar.applyStyle(style: .invisible(withStatusBarColor: Palette[basic: .clear]))
        navigationController.navigationBar.clipsToBounds = true
        present(navigationController, animated: true, completion: nil)
    }
}
