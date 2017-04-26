//
//  PhotoDetailViewController.swift
//  StylistEye
//
//  Created by Martin Stachon on 18.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import KVNProgress

protocol PhotoDetailDelegate: class {
    
    func photoDeleted()
    
}

class PhotoDetailViewController: AbstractViewController {
    
    var imageUrl: URL?
    var imageId: Int?
    
    fileprivate var imageView = UIImageView()
    fileprivate var toolbar = UIToolbar()
    
    weak var delegate: PhotoDetailDelegate?
    
    override func initializeElements() {
        super.initializeElements()
        
        backgroundImage.image = nil
        view.backgroundColor = Palette[custom: .purple]
        
        imageView.contentMode = .scaleAspectFill
        
        let filler1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let filler2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "trash_icon"), style: .plain, target: self, action: #selector(deleteButtonAction))
        deleteButton.tintColor = Palette[custom: .title]
        toolbar.items = [filler1, deleteButton, filler2]
        toolbar.barTintColor = Palette[custom: .purple]
        
        let cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow_icon"), style: .plain, target: self, action: #selector(cancelBarAction))
        cancelButton.tintColor = Palette[custom: .title]
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func addElements() {
        super.addElements()
        
        view.addSubviews(views: [
            imageView,
            toolbar
            ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(view.snp.width).multipliedBy(4.0/3.0)
        }
        
        toolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(imageView.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.kf.setImage(with: imageUrl, placeholder: #imageLiteral(resourceName: "placeholder"))
    }
    
    // MARK: - Actions
    
    func deleteButtonAction() {
        guard let id = imageId else {
            return
        }
        KVNProgress.show()
        let cmd = DeleteOutfitPhotoCommand(id: id).executeCommand() {
            data in
            switch data {
            case let .success(_, objectsArray: _, pagination: _, apiResponse: apiResponse):
                // TODO: @MS
                switch apiResponse {
                case .ok:
                    KVNProgress.dismiss()
                    self.delegate?.photoDeleted()
                    self.dismiss(animated: true, completion: nil)
                case .fail:
                    KVNProgress.showError(withStatus: "Fail code - delete photo")
                }
            case let .failure(message):
                KVNProgress.showError(withStatus: message.message)
            }
        }
    }
    
    func cancelBarAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
