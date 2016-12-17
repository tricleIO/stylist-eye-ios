//
//  StylistListTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 16.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Kingfisher
import UIKit

class StylistListTableViewCell: AbstractTableViewCell {

    // MARK: - Properties
    // MARK: > public
    var stylistName: String? {
        get {
            return stylistNameLabel.text
        }
        set {
            stylistNameLabel.text = newValue
        }
    }
    
    var stylistPhoto: String? {
        get {
            return nil
        }
        set {
            if let url = newValue?.urlValue {
                stylistPhotoView.kf.setImage(with: ImageResource(downloadURL: url))
            }
        }
    }

    var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }
    
    // MARK: > private
    fileprivate let stylistNameLabel = Label()
    fileprivate let descriptionLabel = Label()
    
    fileprivate let stylistPhotoView = ImageView()
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        stylistPhotoView.layer.cornerRadius = 20
        stylistPhotoView.contentMode = .scaleAspectFit
        stylistPhotoView.clipsToBounds = true
        
        stylistNameLabel.textColor = Palette[custom: .title]
        stylistNameLabel.font = SystemFont[.title]
        
        descriptionLabel.textColor = Palette[custom: .purple]
        descriptionLabel.font = SystemFont[.litleDescription]
    }
    
    internal override func addElements() {
        super.addElements()
        
        addSubviews(views:
            [
                stylistNameLabel,
                stylistPhotoView,
                descriptionLabel,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        stylistPhotoView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).inset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        stylistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistPhotoView.snp.trailing).offset(5)
            make.top.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistPhotoView.snp.trailing).offset(5)
            make.top.equalTo(stylistNameLabel.snp.bottom).offset(3)
            make.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView)
        }
    }
}
