//
//  ProductDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class ProductDetailViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: < public
    var mainImageview = ImageViewWithGradient()

    var productInfo: ProductInfo? {
        didSet {
            guard let productInfo = productInfo else {
                return
            }
            reloadProductInformation(productInfo: productInfo)
        }
    }

    // MARK: < private
    fileprivate let productDescriptionLabel = Label()

    fileprivate let footerView = View()

    fileprivate let cameraImageView = ImageView()
    fileprivate let trashImageView = ImageView()

    // MARK: < private 
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        cameraImageView.image = #imageLiteral(resourceName: "cmeraPlus_icon")
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped)))

        trashImageView.image = #imageLiteral(resourceName: "trash_icon")
        trashImageView.contentMode = .scaleAspectFit
        trashImageView.isUserInteractionEnabled = true
        trashImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped)))

        navigationItem.leftBarButtonItem = backButton

        productDescriptionLabel.textColor = Palette[basic: .white]
        productDescriptionLabel.font = SystemFont[.litleDescription]
        productDescriptionLabel.numberOfLines = 0

        mainImageview.image = #imageLiteral(resourceName: "placeholder")

        footerView.backgroundColor = Palette[custom: .purple]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                mainImageview,
                productDescriptionLabel,
                footerView,
            ]
        )

        footerView.addSubviews(views:
            [
                cameraImageView,
                trashImageView,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        mainImageview.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        productDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(view).inset(10)
            make.bottom.equalTo(view).inset(60)
        }

        footerView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(40)
            make.bottom.equalTo(view)
        }

        cameraImageView.snp.makeConstraints { make in
            make.centerX.equalTo(footerView).inset(-50)
            make.centerY.equalTo(footerView)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }

        trashImageView.snp.makeConstraints { make in
            make.centerX.equalTo(footerView).inset(50)
            make.centerY.equalTo(footerView)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[basic: .white]
    }

    // MARK: - User Action
    func cameraImageViewTapped() {
        openCamera()
    }

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions
    fileprivate func reloadProductInformation(productInfo: ProductInfo) {
        productDescriptionLabel.text = productInfo.infoText
    }

    fileprivate func openCamera() {
        let navController = UINavigationController(rootViewController: CameraViewController())
        navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        present(navController, animated: true, completion: nil)
    }
}
