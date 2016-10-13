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

    // MARK: - <Initializable>
    internal override func customInit() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss)))
    }

    // MARK: - Action
    func keyboardDismiss() {
        view.endEditing(true)
    }
}
