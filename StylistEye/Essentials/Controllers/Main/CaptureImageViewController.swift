//
//  CaptureImageViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class CaptureImageViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: < public
    var capturedImage: UIImage? {
        didSet {
            imageView.image = capturedImage
        }
    }
  
    var imagePicked: CameraPickerHandler?

    // MARK: < private
    fileprivate lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
    fileprivate lazy var rightBarbutton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cross_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))

    fileprivate let actionBox = View()

    fileprivate let uploadButton = Button(type: .system)

    fileprivate let imageView = ImageView()

    // MARK: - <Initializable>
    override func initializeElements() {
        super.initializeElements()

        actionBox.backgroundColor = Palette[custom: .purple]

        uploadButton.setImage(#imageLiteral(resourceName: "check_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarbutton
        
        imageView.contentMode = .scaleAspectFit
        
        backgroundImage.image = nil
        backgroundImage.backgroundColor = UIColor.black
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                imageView,
                actionBox,
            ]
        )
        
        actionBox.addSubview(uploadButton)
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(view.snp.width).multipliedBy(4.0/3.0)
        }

        actionBox.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(view)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.centerX.equalTo(actionBox)
            make.centerY.equalTo(actionBox)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }

    // MARK: - User Action
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func uploadButtonTapped() {
        if let image = capturedImage {
            uploadButton.isEnabled = false
            imagePicked?(image)
            dismiss(animated: true, completion: nil)
        }
    }
}
