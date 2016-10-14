//
//  UserDefaultKeys.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

extension UserDefaults {

    /**
     User defaults keys definition.
     - user profile info
     */
    enum UserDefaultsKeys: String, KeyRepresentable {
        
        /// User name info.
        case userProfileInfo
    }
}
