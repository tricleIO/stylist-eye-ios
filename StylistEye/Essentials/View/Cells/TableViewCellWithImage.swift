//
//  TableViewCellWithImage.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import UIKit

class TableViewCellWithImage: AbstractTableViewCell {

    // MARK: - Properties
    // MARK: > public
    var leftCellImage: UIImage? {
        get {
            return leftImageView.image
        }
        set {
            leftImageView.image = newValue
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
    fileprivate let leftImageView = ImageView()

    fileprivate let customTextLabel = Label()

    // MARK: - <Initialize>
    override func initializeElements() {
        super.initializeElements()
        
        customTextLabel.textColor = Palette[custom: .purple]
        
        leftImageView.contentMode = .scaleAspectFit
    }

    override func addElements() {
        super.addElements()

        contentView.addSubviews(views:
            [
                leftImageView,
                customTextLabel,
            ]
        )
    }

    override func setupConstraints() {
        super.setupConstraints()

        customTextLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(leftImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(15)
        }

        leftImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(8)
            make.centerY.equalTo(contentView)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
  
    func leftImageSetFrom(url: URL?) {
        leftImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        leftImageView.kf.cancelDownloadTask()
        leftImageView.image = nil
    }
}
