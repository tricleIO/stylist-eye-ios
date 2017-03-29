//
//  AbstractViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Abstract view controller setup initializable protocol to life-cycle methods.
 */
class AbstractViewController: UIViewController {

    // MARK: - Status bar style
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    let backgroundImage = ImageView(image: #imageLiteral(resourceName: "whiteBg_image"))

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Just added elements to view and apply constraints.
        addElementsAndApplyConstraints()

        /// Load data from API.
        loadData()
    }

    // MARK: - <Initializable>
    internal override func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: Palette[custom: .appColor],
            NSFontAttributeName: SystemFont[.title]
        ]
    }

    internal override func addElements() {
        view.addSubview(backgroundImage)
    }

    internal override func setupBackgroundImage() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    internal override func customInit() {
        // NOTE from Martin: without cancelsTouchesInView, this gesture recognizer causes strange
        // behaviours of UITableViewDelegate - didSelectRowAt not called etc.
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - Action
    func keyboardDismiss() {
        view.endEditing(true)
    }
}
