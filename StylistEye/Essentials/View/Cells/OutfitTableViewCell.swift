//
//  OutfitTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class OutfitTableViewCell: AbstractTableViewCell {

    // MARK: - Properties
    // MARK: > public
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

    var stylistImageString: String? {
        get {
            return String.empty
        }
        set {
            if let url = newValue?.urlValue {
                stylistProfileImageView.kf.setImage(with: ImageResource(downloadURL: url))
            }
        }
    }

    var descriptionText: String? {
        get {
            return descriptionLabel.text.forcedValue
        }
        set {
            descriptionLabel.text = newValue
        }
    }

    var stylistNameText: String? {
        get {
            return stylistNameLabel.text.forcedValue
        }
        set {
            stylistNameLabel.text = newValue
        }
    }

    var zoomButtonCallback: (VoidBlock)?

    // MARK: > private
    fileprivate let mainImageView = ImageView()
    fileprivate let stylistProfileImageView = ImageView()

    fileprivate let coverView = View()

    fileprivate let zoomButton = ImageView(image: #imageLiteral(resourceName: "zoom"))

    fileprivate let descriptionLabel = Label()
    fileprivate let stylistNameLabel = Label()

    // MARK: - <Initializable>
    internal override func initializeElements() {
        super.initializeElements()

        coverView.backgroundColor = Palette[basic: .white]

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.image = #imageLiteral(resourceName: "placeholder")

        stylistProfileImageView.contentMode = .scaleAspectFit
        stylistProfileImageView.clipsToBounds = true
        stylistProfileImageView.layer.cornerRadius = 20
        stylistProfileImageView.image = #imageLiteral(resourceName: "placeholder")

        stylistNameLabel.textColor = Palette[custom: .title]
        stylistNameLabel.numberOfLines = 0
        stylistNameLabel.font = SystemFont[.title]

        descriptionLabel.textColor = Palette[custom: .purple]
        descriptionLabel.font = SystemFont[.litleDescription]
        descriptionLabel.numberOfLines = 0

        zoomButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomButtonTapped)))
        zoomButton.isUserInteractionEnabled = true
        zoomButton.layer.cornerRadius = 15
        zoomButton.clipsToBounds = true
        zoomButton.contentMode = .scaleAspectFit
    }

    internal override func addElements() {
        super.addElements()

        contentView.addSubviews(views:
            [
                coverView,
                mainImageView,
                stylistProfileImageView,
                stylistNameLabel,
                descriptionLabel,
                zoomButton,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        coverView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).inset(5)
            make.bottom.equalTo(contentView).inset(5)
        }

        mainImageView.snp.makeConstraints { make in
            make.leading.equalTo(coverView).inset(10)
            make.trailing.equalTo(coverView).inset(10)
            make.top.equalTo(coverView).inset(10)
            make.height.equalTo(550)
        }

        stylistProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(coverView).inset(10)
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        stylistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(10)
            make.top.equalTo(mainImageView.snp.bottom).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(coverView).inset(10)
            make.trailing.equalTo(coverView).inset(10)
            make.top.equalTo(stylistProfileImageView.snp.bottom).offset(10)
            make.bottom.equalTo(coverView).inset(10)
        }

        zoomButton.snp.makeConstraints { make in
            make.trailing.equalTo(coverView).inset(20)
            make.top.equalTo(coverView).inset(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }

  override func prepareForReuse() {
    super.prepareForReuse()
    
    mainImageView.kf.cancelDownloadTask()
  }
  
    // MARK: - User Action
    func zoomButtonTapped() {
        zoomButtonCallback?()
    }
}
