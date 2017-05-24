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
      imagesPageControl.numberOfPages = images.count
      
      var imageViews = [UIImageView]()
      
      for i in 0..<images.count {
        let imageView = UIImageView()
        imageViews.append(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.setImage(with: images[i].urlValue, placeholder: #imageLiteral(resourceName: "placeholder"))
        imagesScrollContentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
          if i == 0 {
            make.leading.equalToSuperview()
          } else {
            make.leading.equalTo(imageViews[i-1].snp.trailing)
          }
          make.width.equalTo(imagesScrollContainer)
          make.height.equalToSuperview()
          make.top.equalToSuperview()
          make.bottom.equalToSuperview()
        }
      }
      imagesScrollContentView.snp.remakeConstraints { make in
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.top.equalToSuperview()
        make.width.equalTo(imagesScrollContainer).multipliedBy(images.count)
        make.bottom.equalToSuperview()
        make.height.equalToSuperview()
      }
    }
  }
  
  var reviews: [ReviewDTO]? {
    didSet {
      if let reviews = reviews {
        reviewsPageControl.numberOfPages = reviews.count
    
        var reviewViews = [ReviewView]()
        
        for i in 0..<reviews.count {
          let reviewView = ReviewView()
          reviewViews.append(reviewView)
          reviewView.setReview(reviews[i])
          reviewScrollContentView.addSubview(reviewView)
          
          reviewView.snp.makeConstraints { make in
            if i == 0 {
              make.leading.equalToSuperview()
            } else {
              make.leading.equalTo(reviewViews[i-1].snp.trailing)
            }
            make.width.equalTo(reviewScrollContainer)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
          }
        }
        reviewScrollContentView.snp.remakeConstraints { make in
          make.leading.equalToSuperview()
          make.trailing.equalToSuperview()
          make.top.equalToSuperview()
          make.width.equalTo(reviewScrollContainer).multipliedBy(reviews.count)
          make.bottom.equalToSuperview()
          make.height.equalToSuperview()
        }
        reviewScrollView.setNeedsLayout()
        
      } else {
        reviewsPageControl.numberOfPages = 0
      }
    }
  }
  
  var zoomButtonCallback: (VoidBlock)?
  var addPhotoCallback: (VoidBlock)?
  
  // MARK: > private
  fileprivate let imagesScrollContainer = View()
  fileprivate let imagesScrollView = UIScrollView()
  fileprivate let imagesScrollContentView = View()
  fileprivate let imagesPageControl = UIPageControl()
  
  fileprivate var addPhotoOverlay = View()
  fileprivate var addPhotoButton = UIButton()
  fileprivate var addPhotoLabel = UILabel()
  
  fileprivate let reviewScrollContainer = View()
  fileprivate let reviewScrollView = UIScrollView()
  fileprivate let reviewScrollContentView = View()
  fileprivate let reviewsPageControl = UIPageControl()
  
  fileprivate let coverView = View()
  
  fileprivate let zoomButton = ImageView(image: #imageLiteral(resourceName: "zoom"))
  
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
    
    imagesScrollView.isPagingEnabled = true
    imagesScrollView.isScrollEnabled = true
    imagesScrollView.delegate = self
    imagesScrollView.alwaysBounceVertical = false
    
    imagesPageControl.numberOfPages = 0
    imagesPageControl.pageIndicatorTintColor = Palette[custom: .appColor]
    imagesPageControl.currentPageIndicatorTintColor = Palette[custom: .purple]
    imagesPageControl.isUserInteractionEnabled = true
    imagesPageControl.addTarget(self, action: #selector(changeImagePage(sender:)), for: .valueChanged)
    imagesPageControl.hidesForSinglePage = true
    
    addPhotoOverlay.isHidden = true
    addPhotoOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    addPhotoButton.setImage(#imageLiteral(resourceName: "cmeraPlus_icon").withRenderingMode(.alwaysTemplate), for: .normal)
    addPhotoButton.tintColor = Palette[custom: .title]
    addPhotoButton.isUserInteractionEnabled = false
    
    addPhotoLabel.text = StringContainer[.takePhoto]
    addPhotoLabel.textColor = Palette[custom: .title]
    addPhotoLabel.textAlignment = .center
    
    reviewsPageControl.numberOfPages = 0
    reviewsPageControl.pageIndicatorTintColor = Palette[custom: .appColor]
    reviewsPageControl.currentPageIndicatorTintColor = Palette[custom: .purple]
    reviewsPageControl.isUserInteractionEnabled = true
    reviewsPageControl.addTarget(self, action: #selector(changeReviewPage(sender:)), for: .valueChanged)
    reviewsPageControl.hidesForSinglePage = true
    
    zoomButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomButtonTapped)))
    zoomButton.isUserInteractionEnabled = true
    zoomButton.layer.cornerRadius = 15
    zoomButton.clipsToBounds = true
    zoomButton.contentMode = .scaleAspectFit
    
    reviewScrollView.isPagingEnabled = true
    reviewScrollView.isScrollEnabled = true
    reviewScrollView.delegate = self
    
  }
  
  internal override func addElements() {
    super.addElements()
    
    contentView.addSubview(coverView)
    coverView.addSubviews(views: [
      imagesScrollContainer,
      imagesPageControl,
      reviewScrollContainer,
      reviewsPageControl,
      zoomButton
      ])
    
    //imagesScrollContainer.addSubview(addPhotoOverlay)
    //addPhotoOverlay.addSubview(addPhotoButton)
    //addPhotoOverlay.addSubview(addPhotoLabel)
    
    imagesScrollContainer.addSubview(imagesScrollView)
    imagesScrollView.addSubview(imagesScrollContentView)
    
    reviewScrollContainer.addSubview(reviewScrollView)
    reviewScrollView.addSubview(reviewScrollContentView)
  }
  
  internal override func setupConstraints() {
    super.setupConstraints()
    
    coverView.snp.makeConstraints { make in
      make.leading.equalTo(contentView).inset(10)
      make.trailing.equalTo(contentView).inset(10)
      make.top.equalTo(contentView).inset(5)
      make.bottom.equalTo(contentView).inset(5)
    }
    
    imagesScrollContainer.snp.makeConstraints { make in
      make.leading.equalTo(coverView).inset(10)
      make.trailing.equalTo(coverView).inset(10)
      make.top.equalTo(coverView).inset(10)
      make.height.equalTo(imagesScrollContainer.snp.width).multipliedBy(4.0/3.0)
    }
    
    imagesScrollView.snp.makeConstraints { make in
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.top.equalTo(0)
      make.bottom.equalTo(0)
    }
    
    imagesScrollContentView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.width.equalTo(imagesScrollContainer).multipliedBy(1)
      make.bottom.equalToSuperview()
      make.height.equalToSuperview()
    }
    
    imagesPageControl.snp.makeConstraints { make in
      make.centerX.equalTo(coverView)
      make.top.equalTo(imagesScrollContainer.snp.bottom).offset(10)
      make.height.equalTo(10)
    }
    
    /*
    addPhotoOverlay.snp.makeConstraints { make in
      make.leading.equalTo(imagesScrollContainer)
      make.top.equalTo(imagesScrollContainer)
      make.bottom.equalTo(imagesScrollContainer)
      make.trailing.equalTo(imagesScrollContainer)
    }
    
    addPhotoButton.snp.makeConstraints { make in
      make.center.equalTo(addPhotoOverlay)
    }
    
    addPhotoLabel.snp.makeConstraints { make in
      make.topMargin.equalTo(addPhotoButton.snp.bottomMargin).offset(20)
      make.centerX.equalTo(addPhotoButton)
    }
    */
    
    reviewScrollContainer.snp.makeConstraints { make in
      make.leading.equalTo(coverView).inset(10)
      make.trailing.equalTo(coverView).inset(10)
      make.top.equalTo(imagesPageControl.snp.bottom).offset(10)
      make.height.equalTo(150)
    }
    
    reviewScrollView.snp.makeConstraints { make in
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.top.equalTo(0)
      make.bottom.equalTo(0)
    }
    
    reviewScrollContentView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.width.equalTo(reviewScrollContainer).multipliedBy(1)
      make.bottom.equalToSuperview()
      make.height.equalToSuperview()
    }
    
    reviewsPageControl.snp.makeConstraints { make in
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
    
    for subview in reviewScrollContentView.subviews {
      subview.removeFromSuperview()
    }
    reviewScrollView.contentOffset = CGPoint(x: 0, y: 0)
  }
  
  // MARK: - User Action
  func zoomButtonTapped() {
    zoomButtonCallback?()
  }
  
  func photoOverlayTapped() {
    addPhotoCallback?()
  }
  
  func changeReviewPage(sender: AnyObject) -> () {
    let x = CGFloat(reviewsPageControl.currentPage) * reviewScrollView.frame.size.width
    reviewScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
  }
  
  func changeImagePage(sender: AnyObject) -> () {
    let x = CGFloat(imagesPageControl.currentPage) * imagesScrollView.frame.size.width
    imagesScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
  }
  
  func currentImagePage() -> Int {
    return imagesPageControl.currentPage
  }

}

extension WardrobeTableViewCell: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    if scrollView === reviewScrollView {
      let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
      reviewsPageControl.currentPage = Int(pageNumber)
    } else if scrollView === imagesScrollView {
      let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
      imagesPageControl.currentPage = Int(pageNumber)
    }
  }
}
