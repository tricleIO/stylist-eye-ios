//
//  UIImage+base64.swift
//  StylistEye
//
//  Created by Martin Stachon on 05.04.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  func base64() -> String {
    return UIImageJPEGRepresentation(self, 0.9)!.base64EncodedString()
  }
  
  func jpegData() -> Data {
    return UIImageJPEGRepresentation(self, 0.9)!
  }
    
}
