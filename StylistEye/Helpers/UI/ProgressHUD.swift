//
//  ProgressHUD.swift
//  StylistEye
//
//  Created by Martin Stachon on 07.11.17.
//  Copyright © 2017 Westico. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class ProgressHUD {
    
    class func configure() {
//        let kvnConfig = KVNProgressConfiguration.default()
//        kvnConfig?.backgroundType = .solid
//        kvnConfig?.backgroundFillColor = UIColor.clear
//        kvnConfig?.circleStrokeForegroundColor = Palette[custom: .title]
//        kvnConfig?.statusColor = Palette[custom: .title]
//        kvnConfig?.errorColor = Palette[custom: .title]
//        kvnConfig?.successColor = Palette[custom: .title]
//
//        KVNProgress.setConfiguration(kvnConfig)
        
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(Palette[custom: .title])
        
    }
    
    class func show() {
        SVProgressHUD.show()
    }
    
    class func show(_ progress : CGFloat) {
        SVProgressHUD.showProgress(Float(progress))
    }
    
    class func showSuccess() {
        SVProgressHUD.showSuccess(withStatus: nil)
    }
    
    class func showSuccess(withCompletion: (() -> ())) {
        SVProgressHUD.showSuccess(withStatus: nil)
        withCompletion()
    }
    
    class func showError() {
        SVProgressHUD.showError(withStatus: nil)
    }
    
    class func showError(withStatus status: String) {
        SVProgressHUD.showError(withStatus: status)
    }
    
    class func dismiss() {
        SVProgressHUD.popActivity()
    }
    
}
