//
//  QuestionnaireTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 17.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit
import Kingfisher

class QuestionnaireTableViewCell: AbstractTableViewCell {

    // MARK: - Properties
    // MARK: > public
    var mainImage: UIImage? {
        get {
            return mainImageView.image
        }
        set {
            mainImageView.image = newValue
        }
    }
  
    var mainImageString: String? {
        get {
            return String.empty
        }
        set {
            if let url = newValue?.urlValue {
                mainImageView.kf.setImage(with: ImageResource(downloadURL: url))
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
    fileprivate let mainImageView = ImageView()
    fileprivate let zoomImageView = ImageView()

    fileprivate let coverView = View()

    fileprivate let descriptionLabel = Label()

    // MARK: - <Initialize>
    override func initializeElements() {
        super.initializeElements()

        descriptionLabel.textColor = Palette[custom: .appColor]
        descriptionLabel.font = SystemFont[.description]

        coverView.backgroundColor = Palette[basic: .white]

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
    }

    override func addElements() {
        super.addElements()

        contentView.addSubviews(views:
            [
                coverView,
            ]
        )
        
        coverView.addSubviews(views:
            [
                mainImageView,
                //descriptionLabel,
            ]
        )
    }

    override func setupConstraints() {
        super.setupConstraints()

        coverView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).inset(5)
            make.bottom.equalTo(contentView).inset(5)
        }

        // TODO: @MS - insets
//        descriptionLabel.snp.makeConstraints { make in
//            make.leading.equalTo(coverView).inset(10)
//            make.trailing.equalTo(coverView).inset(10)
//            make.top.equalTo(mainImageView.snp.bottom).offset(10)
//        }

        mainImageView.snp.makeConstraints { make in
            make.leading.equalTo(coverView).inset(10)
            make.trailing.equalTo(coverView).inset(10)
            make.top.equalTo(coverView).inset(10)
            make.bottom.equalTo(coverView).inset(10)
            make.height.equalTo(mainImageView.snp.width).multipliedBy(4.0/3.0)
        }
    }
}
