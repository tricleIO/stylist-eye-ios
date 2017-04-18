//
//  OutfitDetailTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Kingfisher
import UIKit

protocol OutfitDetailCellDelegateProtocol: class {
    
    func zoomTapped(cell: OutfitDetailTableViewCell)
    
}

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
    
    fileprivate var addPhotoOverlay = View()
    fileprivate var addPhotoButton = UIButton()
    fileprivate var addPhotoLabel = UILabel()
    
    fileprivate let zoomImageView = ImageView(image: #imageLiteral(resourceName: "zoom"))
    
    fileprivate let coverView = View()

    fileprivate let customTextLabel = Label()
    
    weak var delegate: OutfitDetailCellDelegateProtocol?

    // MARK: - <Initialize>
    override func initializeElements() {
        super.initializeElements()

        addPhotoOverlay.isHidden = true
        
        addPhotoOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addPhotoButton.setImage(#imageLiteral(resourceName: "cmeraPlus_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        addPhotoButton.tintColor = Palette[custom: .title]
        addPhotoButton.isUserInteractionEnabled = false
        
        addPhotoLabel.text = StringContainer[.noPhotoYet]
        addPhotoLabel.textColor = Palette[custom: .title]
        addPhotoLabel.textAlignment = .center
        
        coverView.backgroundColor = Palette[basic: .white]

        customTextLabel.textColor = Palette[custom: .appColor]
        customTextLabel.font = SystemFont[.title]

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.isUserInteractionEnabled = true
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomTapped))
        zoomImageView.addGestureRecognizer(zoomTap)
    }

    override func addElements() {
        super.addElements()

        contentView.addSubview(coverView)
        coverView.addSubviews(views:
            [
                customTextLabel,
                mainImageView,
                zoomImageView,
            ]
        )
        
        mainImageView.addSubview(addPhotoOverlay)
        addPhotoOverlay.addSubview(addPhotoButton)
        addPhotoOverlay.addSubview(addPhotoLabel)
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
            make.height.equalTo(mainImageView.snp.width).multipliedBy(4.0/3.0)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.center.equalTo(mainImageView)
        }
        
        addPhotoLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(addPhotoButton.snp.bottomMargin).offset(20)
            make.centerX.equalTo(addPhotoButton)
        }
        
    }
    
    func showPlaceholder() {
        addPhotoOverlay.isHidden = false
        mainImageView.image = #imageLiteral(resourceName: "background_image")
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.kf.cancelDownloadTask()
        addPhotoOverlay.isHidden = true
    }
    
    func zoomTapped() {
        delegate?.zoomTapped(cell: self)
    }
    
}
