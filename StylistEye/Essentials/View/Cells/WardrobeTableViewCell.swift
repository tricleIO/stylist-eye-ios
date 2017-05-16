//
//  WardrobeTableViewCell.swift
//  StylistEye
//
//  Created by Martin Stachon on 09.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class WardrobeTableViewCell: AbstractTableViewCell {
  
  // MARK: - Properties
  // MARK: > public
  var images = [String]() {
    didSet {
      self.stackImageView.images = images
    }
  }
  
  var reviews: [ReviewDTO]? {
    didSet {
      pageControl.numberOfPages = reviews?.count ?? 0
      self.switchReviewPage(index: 0)
    }
  }
  
  var zoomButtonCallback: (VoidBlock)?
  var addPhotoCallback: (VoidBlock)?
  
  // MARK: > private
  fileprivate let stackImageView = ImageSlider()
  
  fileprivate var addPhotoOverlay = View()
  fileprivate var addPhotoButton = UIButton()
  fileprivate var addPhotoLabel = UILabel()
  
  fileprivate let reviewScrollView = UIScrollView()
  fileprivate let reviewContainer = View()
  
  fileprivate let stylistProfileImageView = ImageView()
  
  fileprivate let stylistRatingView = RatingView()
  
  fileprivate let coverView = View()
  
  fileprivate let zoomButton = ImageView(image: #imageLiteral(resourceName: "zoom"))
  
  fileprivate let descriptionLabel = Label()
  fileprivate let stylistNameLabel = Label()
  
  fileprivate let pageControl = UIPageControl()
  
  // MARK: - <Initializable>
  internal override func initializeElements() {
    super.initializeElements()
    
    coverView.backgroundColor = Palette[basic: .white]
    
    /*
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.clipsToBounds = true
    mainImageView.image = #imageLiteral(resourceName: "placeholder")
    mainImageView.kf.indicatorType = .activity
    */
    
    //stackImageView.delegate = self
    //stackImageView.dataSource = self
    
    addPhotoOverlay.isHidden = true
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
    
    stylistRatingView.rating = 0
    
    stylistNameLabel.textColor = Palette[custom: .title]
    stylistNameLabel.numberOfLines = 0
    stylistNameLabel.font = SystemFont[.title]
    
    descriptionLabel.textColor = Palette[custom: .purple]
    descriptionLabel.font = SystemFont[.litleDescription]
    descriptionLabel.numberOfLines = 0
    
    pageControl.numberOfPages = 0
    pageControl.pageIndicatorTintColor = Palette[custom: .appColor]
    pageControl.currentPageIndicatorTintColor = Palette[custom: .purple]
    
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
      stackImageView,
      reviewScrollView,
      pageControl,
      zoomButton
      ])
    
    reviewScrollView.addSubview(reviewContainer)
    reviewContainer.addSubviews(views: [
      stylistProfileImageView,
      stylistRatingView,
      stylistNameLabel,
      descriptionLabel,
    ])
    
    stackImageView.addSubview(addPhotoOverlay)
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
    
    stackImageView.snp.makeConstraints { make in
      make.leading.equalTo(coverView).inset(10)
      make.trailing.equalTo(coverView).inset(10)
      make.top.equalTo(coverView).inset(10)
      make.height.equalTo(stackImageView.snp.width).multipliedBy(4.0/3.0)
    }
    
    addPhotoOverlay.snp.makeConstraints { make in
      make.leading.equalTo(stackImageView)
      make.top.equalTo(stackImageView)
      make.bottom.equalTo(stackImageView)
      make.trailing.equalTo(stackImageView)
    }
    
    addPhotoButton.snp.makeConstraints { make in
      make.center.equalTo(addPhotoOverlay)
    }
    
    addPhotoLabel.snp.makeConstraints { make in
      make.topMargin.equalTo(addPhotoButton.snp.bottomMargin).offset(20)
      make.centerX.equalTo(addPhotoButton)
    }
    
    reviewScrollView.snp.makeConstraints { make in
      make.leading.equalTo(coverView).inset(10)
      make.trailing.equalTo(coverView).inset(10)
      make.top.equalTo(stackImageView.snp.bottom).offset(10)
    }
    
    // scroll content
    
    reviewContainer.snp.makeConstraints { make in
      make.leading.equalTo(reviewScrollView)
      make.trailing.equalTo(reviewScrollView)
      make.top.equalTo(reviewScrollView)
      make.bottom.equalTo(reviewScrollView)
      make.width.equalTo(reviewScrollView)
      make.height.equalTo(reviewScrollView)
    }
    
    stylistProfileImageView.snp.makeConstraints { make in
      make.leading.equalTo(reviewContainer).inset(10)
      make.top.equalTo(reviewContainer).inset(10)
      make.width.equalTo(40)
      make.height.equalTo(40)
    }
    
    stylistNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(10)
      make.top.equalTo(reviewContainer).inset(15)
      make.height.equalTo(30)
      make.width.equalTo(200)
    }
    
    stylistRatingView.snp.makeConstraints { make in
      make.centerY.equalTo(stylistNameLabel)
      make.trailing.equalTo(reviewContainer).inset(10)
      make.height.equalTo(20)
      make.width.equalTo(100)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.leading.equalTo(reviewContainer).inset(10)
      make.trailing.equalTo(reviewContainer).inset(10)
      make.top.equalTo(stylistProfileImageView.snp.bottom).offset(10)
      make.bottom.equalTo(reviewContainer).inset(10)
    }
    
    // end scroll content
    
    pageControl.snp.makeConstraints { make in
      make.centerX.equalTo(coverView)
      make.top.equalTo(reviewScrollView.snp.bottom).offset(10)
      make.bottom.equalTo(coverView).inset(10)
      make.height.equalTo(10)
    }
    
    zoomButton.snp.makeConstraints { make in
      make.trailing.equalTo(coverView).inset(20)
      make.top.equalTo(coverView).inset(20)
      make.width.equalTo(30)
      make.height.equalTo(30)
    }
  }
  
//  func showPlaceholder() {
//    addPhotoOverlay.isHidden = false
//    mainImageView.image = #imageLiteral(resourceName: "background_image")
//  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    //mainImageView.kf.cancelDownloadTask()
    //mainImageView.image = nil
    addPhotoOverlay.isHidden = true
  }
  
  func switchReviewPage(index: Int) {
    guard let review = reviews?[safe: index] else {
      stylistNameLabel.text = nil
      stylistProfileImageView.image = nil
      descriptionLabel.text = nil
      descriptionLabel.text = nil
      stylistRatingView.rating = 0
      stylistRatingView.isHidden = true
      return
    }
    
    if let url = review.stylist?.photo?.image?.urlValue {
      stylistProfileImageView.kf.setImage(with: ImageResource(downloadURL: url))
    }

    descriptionLabel.text = review.comment
    
    if let stylistName = review.stylist?.givenName, let stylistLastname = review.stylist?.familyName {
      stylistNameLabel.text = stylistName + String.space + stylistLastname
    }
    
    stylistRatingView.isHidden = false
    stylistRatingView.rating = review.rating ?? 0
    
  }
  
  // MARK: - User Action
  func zoomButtonTapped() {
    zoomButtonCallback?()
  }
  
  func photoOverlayTapped() {
    addPhotoCallback?()
  }

}
