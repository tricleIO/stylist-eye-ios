//
//  TextField.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override func draw(_ rect: CGRect) {
        let startingPoint = CGPoint(x: rect.minX + 10, y: rect.maxY)
        let endingPoint  = CGPoint(x: rect.maxX - 10, y: rect.maxY)
        let path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 0.5
        let strokeColor = Palette[custom: .appColor]
        strokeColor.setStroke()
        strokeColor.set()
        strokeColor.setFill()
        path.stroke()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

        font = SystemFont[.description]
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        font = SystemFont[.description]
        initialize()
    }
}
