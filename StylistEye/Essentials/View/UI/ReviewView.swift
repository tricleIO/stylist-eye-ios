//
//  ReviewView.swift
//  StylistEye
//
//  Created by Martin Stachon on 16.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ReviewView: View {
  
  fileprivate let stylistProfileImageView = ImageView()
  
  fileprivate let stylistRatingView = RatingView()
  
  fileprivate let descriptionLabel = Label()
  
  fileprivate let stylistNameLabel = Label()
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  required init(frame: CGRect) {
    super.init(frame: frame)
    
    addElementsAndApplyConstraints()
  }
  
  override func initializeElements() {
    super.initializeElements()
    
    stylistProfileImageView.contentMode = .scaleAspectFit
    stylistProfileImageView.clipsToBounds = true
    stylistProfileImageView.layer.cornerRadius = 20
    stylistProfileImageView.image = #imageLiteral(resourceName: "placeholder")
    
    stylistRatingView.rating = 0
    
    stylistNameLabel.textColor = Palette[custom: .title]
    stylistNameLabel.numberOfLines = 1
    stylistNameLabel.font = SystemFont[.title]
    
    descriptionLabel.textColor = Palette[custom: .purple]
    descriptionLabel.font = SystemFont[.litleDescription]
    descriptionLabel.numberOfLines = 0
  }
  
  override func addElements() {
    super.addElements()
    
    addSubviews(views: [
      stylistProfileImageView,
      stylistRatingView,
      stylistNameLabel,
      descriptionLabel,
      ])
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    stylistProfileImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(10)
      make.top.equalToSuperview().inset(10)
      make.width.equalTo(40)
      make.height.equalTo(40)
    }
    
    stylistNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(stylistProfileImageView.snp.trailing).offset(10)
      make.top.equalTo(stylistProfileImageView)
      make.trailing.equalToSuperview()
    }
    
    stylistRatingView.snp.makeConstraints { make in
      make.leading.equalTo(stylistNameLabel)
      make.bottom.equalTo(stylistProfileImageView)
      make.height.equalTo(15)
      make.trailing.equalToSuperview()
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(10)
      make.top.equalTo(stylistProfileImageView.snp.bottom).offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
  }
  
  func setReview(_ review: ReviewDTO?) {
    guard let review = review else {
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
  
  
}
