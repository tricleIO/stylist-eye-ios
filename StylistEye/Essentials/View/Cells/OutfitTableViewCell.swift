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

class OutfitTableViewCell: AbstractTableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    var addPhotoCallback: (VoidBlock)?
    
    var mosaicImages: [String]? {
        didSet {
            /*
            if let mosaicImages = mosaicImages {
                self.mosaicImages = Array(mosaicImages.prefix(through: min(3, mosaicImages.count-1) ))
                imageMosaicContainer.isHidden = false
                imageMosaicCollectionView.reloadData()
            }
            */
        }
    }
    
    // MARK: > private
    fileprivate let mainImageView = ImageView()
    
    fileprivate let imageMosaicContainer = View()
    //fileprivate var imageMosaicCollectionView: UICollectionView!
    fileprivate var addPhotoOverlay = View()
    fileprivate var addPhotoButton = UIButton()
    fileprivate var addPhotoLabel = UILabel()
    
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
        
        imageMosaicContainer.isHidden = true
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = .horizontal
        
        /*
        // TODO: https://cocoapods.org/pods/ADMozaicCollectionViewLayout
        imageMosaicCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionLayout)
        imageMosaicCollectionView.collectionViewLayout = collectionLayout
        imageMosaicCollectionView.isScrollEnabled = false
        imageMosaicCollectionView.dataSource = self
        imageMosaicCollectionView.delegate = self
        imageMosaicCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        imageMosaicCollectionView.backgroundColor = UIColor.white
        imageMosaicCollectionView.isUserInteractionEnabled = false
        */
        
        addPhotoOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addPhotoButton.setImage(#imageLiteral(resourceName: "cmeraPlus_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        addPhotoButton.tintColor = Palette[custom: .title]
        addPhotoButton.isUserInteractionEnabled = false
        
        addPhotoLabel.text = StringContainer[.takePhoto]
        addPhotoLabel.textColor = Palette[custom: .title]
        addPhotoLabel.textAlignment = .center
        
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
        
        contentView.addSubview(coverView)
        coverView.addSubviews(views: [
            mainImageView,
            imageMosaicContainer,
            stylistProfileImageView,
            stylistNameLabel,
            descriptionLabel,
            zoomButton
        ])
        
        //imageMosaicContainer.addSubview(imageMosaicCollectionView)
        imageMosaicContainer.addSubview(addPhotoOverlay)
        addPhotoOverlay.addSubview(addPhotoButton)
        addPhotoOverlay.addSubview(addPhotoLabel)
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
            make.height.equalTo(mainImageView.snp.width).multipliedBy(4.0/3.0)
        }
        
        imageMosaicContainer.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView)
            make.trailing.equalTo(mainImageView)
            make.top.equalTo(mainImageView)
            make.bottom.equalTo(mainImageView)
        }
        
        /*
        imageMosaicCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(imageMosaicContainer)
            make.trailing.equalTo(imageMosaicContainer)
            make.top.equalTo(imageMosaicContainer)
            make.bottom.equalTo(imageMosaicContainer)
        }
        */
        
        addPhotoOverlay.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView)
            make.top.equalTo(mainImageView)
            make.bottom.equalTo(mainImageView)
            make.trailing.equalTo(mainImageView)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.center.equalTo(addPhotoOverlay)
        }
        
        addPhotoLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(addPhotoButton.snp.bottomMargin).offset(20)
            make.centerX.equalTo(addPhotoButton)
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
        imageMosaicContainer.isHidden = true
        mosaicImages = nil
    }
    
    // MARK: - User Action
    func zoomButtonTapped() {
        zoomButtonCallback?()
    }
    
    func photoOverlayTapped() {
        addPhotoCallback?()
    }
    
    // MARK: - UICollectionViewDataSource
    
    class ImageCell: UICollectionViewCell {
        
        var imageView: UIImageView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.leading.equalTo(self.contentView)
                make.trailing.equalTo(self.contentView)
                make.top.equalTo(self.contentView)
                make.bottom.equalTo(self.contentView)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            imageView.kf.cancelDownloadTask()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mosaicImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        guard let image = mosaicImages?[safe: indexPath.item] else {
            return cell
        }
        cell.imageView.kf.setImage(with: URL(string: image))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width/2
        let coef: CGFloat
        if indexPath.item % 3 == 0 {
            coef = 2.0/5.0
        } else {
            coef = 3.0/5.0
        }
        let h = collectionView.frame.height*coef
        return CGSize(width: w, height: h)
    }
}
