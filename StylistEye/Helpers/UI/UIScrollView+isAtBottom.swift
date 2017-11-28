//
//  UIScrollView+isAtBottom.swift
//  StylistEye
//
//  Created by Martin Stachon on 13.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation


import Foundation
import UIKit

extension UIScrollView {
  
  func isAtBottom() -> Bool {
    return self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height)
  }
  
}
