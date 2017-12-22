//
//  QuestionnaireDetailViewController.swift
//  StylistEye
//
//  Created by Michal Severín on 17.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class QuestionnaireDetailViewController: AbstractViewController {
    
    // MARK: - Properties
    // MARK: < public
    var mainImageview = ImageView() // ImageViewWithGradient
    
    var item: CurrentOutfitDTO?
    
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
        
        trashImageView.setImage(#imageLiteral(resourceName: "trash_icon"), for: .normal)
        trashImageView.contentMode = .scaleAspectFit
        trashImageView.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = backButton
        
        productDescriptionLabel.textColor = Palette[basic: .white]
        productDescriptionLabel.font = SystemFont[.litleDescription]
        productDescriptionLabel.numberOfLines = 0
        
        backgroundImage.image = nil
        backgroundImage.backgroundColor = Palette[custom: .purple]
        //mainImageview.image = #imageLiteral(resourceName: "placeholder")
        mainImageview.contentMode = .scaleAspectFit
        mainImageview.backgroundColor = .black
        
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
                trashImageView,
                ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        mainImageview.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.greaterThanOrEqualTo(view)
            make.centerY.equalTo(view).priority(750)
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
        
        trashImageView.snp.makeConstraints { make in
            make.centerX.equalTo(footerView)
            make.centerY.equalTo(footerView)
            make.height.equalTo(50)
            make.width.equalTo(50)
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
        
        if item?.isPlaceholder ?? false {
            trashImageView.isEnabled = false
            return
        }
    }
    
    // MARK: - User Action
    
    func deleteTapped() {
        guard let photoId = item?.photo?.id else {
            return
        }
        let deleteCommand = DeleteCurrentOutfitPhotoCommand(id: photoId)
        
        ProgressHUD.show()
        deleteCommand.executeCommand {
            data in
            
            switch data {
            case let .success(_, objectsArray: _, _, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    ProgressHUD.showSuccess()
                    self.navigationController?.popViewController(animated: true)
                case .fail:
                    ProgressHUD.showError(withStatus: StringContainer[.errorOccured])
                }
            case let .failure(message):
                ProgressHUD.showError(withStatus: StringContainer[.errorOccured])
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
    
    
}
