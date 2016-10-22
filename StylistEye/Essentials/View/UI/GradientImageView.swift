//
//  GradientImageView.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class ImageViewWithGradient: ImageView {

    required init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override convenience init(image: UIImage?, highlightedImage: UIImage?) {
        self.init(image: image, highlightedImage: highlightedImage)
    }

    override convenience init(image: UIImage?) {
        self.init(image: image)
    }

    fileprivate func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, Palette[custom: .purple].cgColor]
        gradient.locations = [0.0, 0.8, 0.9, 1.0]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        layer.addSublayer(gradient)
    }
}
