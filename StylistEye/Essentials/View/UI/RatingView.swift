//
//  RatingView.swift
//  StylistEye
//
//  Created by Martin Stachon on 09.05.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import UIKit

class RatingView: View {
  
  // MARK: - Properties
  var rating: Int? {
    didSet {
      guard let rating = rating, rating <= 5 else {
        return
      }
      var firstStartImageView: ImageView?
      var cycle: Int = 0
      for _ in 0 ..< 5 {
        cycle += 1
        let starImageView: ImageView
        if cycle <= rating {
          starImageView = ImageView(image: #imageLiteral(resourceName: "fullStar"))
        }
        else {
          starImageView = ImageView(image: #imageLiteral(resourceName: "emptyStar"))
        }
        starImageView.contentMode = .scaleAspectFit
        addSubview(starImageView)
        if let firstStartImageView = firstStartImageView {
          starImageView.snp.makeConstraints { make in
            make.leading.equalTo(firstStartImageView.snp.trailing).offset(5)
            make.height.equalTo(15)
            make.width.equalTo(15)
            make.top.equalTo(self)
          }
        }
        else {
          starImageView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.height.equalTo(15)
            make.width.equalTo(15)
            make.top.equalTo(self)
          }
        }
        firstStartImageView = starImageView
      }
    }
  }
}
