//
//  ImageSlider.swift
//  StylistEye
//
//  Created by Martin Stachon on 16.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ImageSlider: UIView {
  
  let pages = 2
  var images = [String]() {
    didSet {
      for i in 0..<pages {
        if let image = images[safe: i] {
          imageViews[i].kf.setImage(with: images[i].urlValue)
        } else {
          imageViews[i].image = #imageLiteral(resourceName: "placeholder")
        }
      }
    }
  }
  var currentPage = 0
  let stackOffset: CGFloat = 10
  
  fileprivate var imageViews = [UIImageView]()
  fileprivate var nextButton = UIButton(type: .custom)
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  func setup() {
    imageViews = [UIImageView]()
    for i in 0..<pages {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.layer.shadowColor = UIColor.black.cgColor
      imageView.layer.shadowRadius = 4
      imageViews.append(imageView)
      self.addSubview(imageView)
    }
    
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
    rightSwipe.direction = .right
    self.addGestureRecognizer(rightSwipe)
    
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
    leftSwipe.direction = .left
    self.addGestureRecognizer(leftSwipe)
    
    self.isUserInteractionEnabled = true
    
    nextButton.setImage(#imageLiteral(resourceName: "message_disclButton_image").withRenderingMode(.alwaysTemplate), for: .normal)
    nextButton.tintColor = Palette[custom: .purple]
    nextButton.layer.zPosition = 1000
    self.addSubview(nextButton)
    
    nextButton.snp.makeConstraints {
      make in
      
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(16)
    }
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(swipeRight))
    nextButton.addGestureRecognizer(tapGesture)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let currentImage = imageViews[currentPage]
    let otherImage = imageViews[(currentPage + 1) % 2]
    
    bringSubview(toFront: currentImage)
    
    currentImage.frame = CGRect(x: 0, y: 0, width: self.frame.width-stackOffset, height: self.frame.height-stackOffset)
    otherImage.frame = CGRect(x: stackOffset, y: stackOffset, width: self.frame.width-stackOffset, height: self.frame.height-stackOffset)
    
    //bringSubview(toFront: nextButton)
  }
  
  func swipeRight() {
    currentPage = ( currentPage + 1 ) % pages
    UIView.animate(withDuration: 0.3, animations: {
      self.layoutSubviews()
    })
  }
  
  func swipeLeft() {
    currentPage = max( currentPage - 1, 0 )
    UIView.animate(withDuration: 0.3, animations: {
      self.layoutSubviews()
    })
  }
  
  
}
