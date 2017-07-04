//
//  WardrobeItemDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit
import KVNProgress

class WardrobeItemDetailViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: < public
    var mainImageview = ImageView() // ImageViewWithGradient

    var wardrobeItem: WardrobeDTO?
    var photoIndex = -1

    // MARK: < private
    fileprivate let productDescriptionLabel = Label()

    fileprivate let footerView = View()

    fileprivate let cameraImageView = Button()
    fileprivate let trashImageView = Button()

    // MARK: < private 
    fileprivate lazy var backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        cameraImageView.setImage(#imageLiteral(resourceName: "cmeraPlus_icon"), for: .normal)
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped)))

        trashImageView.setImage(#imageLiteral(resourceName: "trash_icon"), for: .normal)
        trashImageView.contentMode = .scaleAspectFit
        trashImageView.isUserInteractionEnabled = true
        trashImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteTapped)))

        navigationItem.leftBarButtonItem = backButton

        productDescriptionLabel.textColor = Palette[basic: .white]
        productDescriptionLabel.font = SystemFont[.litleDescription]
        productDescriptionLabel.numberOfLines = 0

        backgroundImage.image = nil
        backgroundImage.backgroundColor = UIColor.black
        //mainImageview.image = #imageLiteral(resourceName: "placeholder")
        mainImageview.contentMode = .scaleAspectFit

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
          make.leading.equalTo(view)
          make.trailing.equalTo(view)
          make.top.equalTo(view)
          make.height.equalTo(view.snp.width).multipliedBy(4.0/3.0)
        }

        productDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(view).inset(10)
            make.bottom.equalTo(view).inset(60)
        }

        footerView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(mainImageview.snp.bottom)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureToolbar()
    }
    
    func configureToolbar() {
        
        if wardrobeItem?.isPlaceholder ?? false {
            cameraImageView.isEnabled = false
            trashImageView.isEnabled = false
            return
        }
        
        let photosCount = wardrobeItem?.photos?.count ?? 0
        switch photosCount {
        case 0:
            // no photo
            cameraImageView.setImage(#imageLiteral(resourceName: "camera_icon"), for: .normal)
            cameraImageView.isEnabled = true
            trashImageView.isEnabled = false
        case 1:
            // one photo
            cameraImageView.setImage(#imageLiteral(resourceName: "cmeraPlus_icon"), for: .normal)
            cameraImageView.isEnabled = true
            trashImageView.isEnabled = true
        case 2:
            // two photos
            cameraImageView.setImage(#imageLiteral(resourceName: "cmeraPlus_icon"), for: .normal)
            cameraImageView.isEnabled = false
            trashImageView.isEnabled = true
        default:
            print("unknown photo index!")
            break
        }
    }

    // MARK: - User Action
    func cameraImageViewTapped() {
        openCamera()
    }
    
    func deleteTapped() {
        guard let photoId = wardrobeItem?.photos?[safe: photoIndex]?.id,
        let photoType = wardrobeItem?.photos?[safe: photoIndex]?.type else {
            return
        }
        let deleteCommand = DeleteWardrobePhotoCommand(id: photoId, type: photoType)
        
        KVNProgress.show()
        deleteCommand.executeCommand {
            data in
            
            switch data {
            case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    KVNProgress.showSuccess()
                    self.navigationController?.popViewController(animated: true)
                case .fail:
                    KVNProgress.showError(withStatus: "Delete failed")
                }
            case let .failure(message):
                KVNProgress.showError(withStatus: message.message)
            }
        }
    }

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions
    fileprivate func reloadProductInformation(productInfo: ProductInfo) {
        productDescriptionLabel.text = productInfo.infoText
    }

    fileprivate func openCamera() {
        let cameraController = CameraViewController()
        let photosCount = wardrobeItem?.photos?.count ?? 0
        guard let wardrobeId = wardrobeItem?.wardrobeId else { return }
        
        cameraController.imagePicked = {
            image in
            
            let imageJpeg = image.jpegData()
            self.mainImageview.image = image
            
            if photosCount > 0 {
                let uploadCommand = UploadWardrobeSecondPhotoCommand(id: wardrobeId, image: image, imageData: imageJpeg)
                
                UploadQueueManager.main.push(item: uploadCommand)
                self.photoIndex = 2
                self.navigationController?.popViewController(animated: true)
                
//                KVNProgress.show()
//                uploadCommand.executeCommand {
//                    data in
//                    
//                    switch data {
//                    case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
//                        // TODO: @MS
//                        switch apiResponse {
//                        case .ok:
//                            KVNProgress.showSuccess()
//                            self.photoIndex = 2
//                            self.navigationController?.popViewController(animated: true)
//                        case .fail:
//                            KVNProgress.showError(withStatus: "Upload failed")
//                        }
//                    case let .failure(message):
//                        KVNProgress.showError(withStatus: message.message)
//                    }
//                }
            } else {
                let uploadCommand = UploadWardrobePhotoCommand(id: wardrobeId, image: image, imageData: imageJpeg)
                
                UploadQueueManager.main.push(item: uploadCommand)
                self.photoIndex = 1
                self.navigationController?.popViewController(animated: true)
                
//                KVNProgress.show()
//                uploadCommand.executeCommand {
//                    data in
//                    
//                    switch data {
//                    case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
//                        // TODO: @MS
//                        switch apiResponse {
//                        case .ok:
//                            KVNProgress.showSuccess()
//                            self.photoIndex = 1
//                            self.navigationController?.popViewController(animated: true)
//                        case .fail:
//                            KVNProgress.showError(withStatus: "Upload failed")
//                        }
//                    case let .failure(message):
//                        KVNProgress.showError(withStatus: message.message)
//                    }
//                }
            }
        }
        let navController = UINavigationController(rootViewController: cameraController)
        navController.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[custom: .purple]))
        present(navController, animated: true, completion: nil)
    }
}
