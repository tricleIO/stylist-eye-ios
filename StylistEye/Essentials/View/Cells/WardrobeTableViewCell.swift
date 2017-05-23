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
      if let reviews = reviews {
        pageControl.numberOfPages = reviews.count
        
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
        pageControl.numberOfPages = 0
      }
    }
  }
  
  var zoomButtonCallback: (VoidBlock)?
  var addPhotoCallback: (VoidBlock)?
  
  // MARK: > private
  fileprivate let stackImageView = ImageSlider()
  
  fileprivate var addPhotoOverlay = View()
  fileprivate var addPhotoButton = UIButton()
  fileprivate var addPhotoLabel = UILabel()
  
  fileprivate let reviewScrollContainer = View()
  fileprivate let reviewScrollView = UIScrollView()
  fileprivate let reviewScrollContentView = View()
  
  fileprivate let coverView = View()
  
  fileprivate let zoomButton = ImageView(image: #imageLiteral(resourceName: "zoom"))
  
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
    
    pageControl.numberOfPages = 0
    pageControl.pageIndicatorTintColor = Palette[custom: .appColor]
    pageControl.currentPageIndicatorTintColor = Palette[custom: .purple]
    pageControl.isUserInteractionEnabled = true
    pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
    
    zoomButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomButtonTapped)))
    zoomButton.isUserInteractionEnabled = true
    zoomButton.layer.cornerRadius = 15
    zoomButton.clipsToBounds = true
    zoomButton.contentMode = .scaleAspectFit
    
    reviewScrollView.isPagingEnabled = true
    reviewScrollView.isScrollEnabled = true
    reviewScrollView.delegate = self
    
    pageControl.hidesForSinglePage = true
  }
  
  internal override func addElements() {
    super.addElements()
    
    contentView.addSubview(coverView)
    coverView.addSubviews(views: [
      stackImageView,
      reviewScrollContainer,
      pageControl,
      zoomButton
      ])
    
    stackImageView.addSubview(addPhotoOverlay)
    addPhotoOverlay.addSubview(addPhotoButton)
    addPhotoOverlay.addSubview(addPhotoLabel)
    
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
    
    reviewScrollContainer.snp.makeConstraints { make in
      make.leading.equalTo(coverView).inset(10)
      make.trailing.equalTo(coverView).inset(10)
      make.top.equalTo(stackImageView.snp.bottom).offset(10)
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
  
  func changePage(sender: AnyObject) -> () {
    let x = CGFloat(pageControl.currentPage) * reviewScrollView.frame.size.width
    reviewScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
  }

}

extension WardrobeTableViewCell: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
  }
}
