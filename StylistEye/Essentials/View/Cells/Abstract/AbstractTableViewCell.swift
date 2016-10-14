//
//  AbstractTableViewCell.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/**
 Abstract tablelview view cell setup initializable protocol constructor methods.
 */
class AbstractTableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addElementsAndApplyConstraints()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addElementsAndApplyConstraints()
    }
}
