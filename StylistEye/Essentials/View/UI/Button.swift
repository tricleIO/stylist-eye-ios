//
//  Button.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class Button: UIButton {

    required override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel?.font = SystemFont[.title]
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        titleLabel?.font = SystemFont[.title]
        initialize()
    }
}
