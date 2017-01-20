//
//  OutfitDetailTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Kingfisher
import UIKit

class OutfitDetailTableViewCell: AbstractTableViewCell {

    // MARK: - Properties
    // MARK: > public
    var mainImageString: String? {
        get {
            return nil
        }
        set {
            if let url = newValue?.urlValue {
                mainImageView.kf.setImage(with: ImageResource(downloadURL: url))
            }
        }
    }

    var labelText: String? {
        get {
            return customTextLabel.text
        }
        set {
            customTextLabel.text = newValue
        }
    }

    // MARK: > private
    fileprivate let mainImageView = ImageView()
    fileprivate let zoomImageView = ImageView(image: #imageLiteral(resourceName: "zoom"))
    
    fileprivate let coverView = View()

    fileprivate let customTextLabel = Label()

    // MARK: - <Initialize>
    override func initializeElements() {
        super.initializeElements()

        coverView.backgroundColor = Palette[basic: .white]

        customTextLabel.textColor = Palette[custom: .appColor]
        customTextLabel.font = SystemFont[.title]

        mainImageView.contentMode = .scaleAspectFit
        zoomImageView.contentMode = .scaleAspectFit
    }

    override func addElements() {
        super.addElements()

        contentView.addSubviews(views:
            [
                coverView,
                customTextLabel,
                zoomImageView,
            ]
        )

        coverView.addSubview(mainImageView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        zoomImageView.snp.makeConstraints { make in
            make.trailing.equalTo(coverView).inset(10)
            make.top.equalTo(coverView).inset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        coverView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(customTextLabel.snp.bottom).offset(15)
            make.height.equalTo(200)
            make.bottom.equalTo(contentView).inset(5)
        }

        customTextLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(25)
        }

        mainImageView.snp.makeConstraints { make in
            make.leading.equalTo(coverView).inset(10)
            make.top.equalTo(coverView).inset(10)
            make.bottom.equalTo(coverView).inset(10)
            make.trailing.equalTo(coverView).inset(10)
        }
    }
}
