//
//  CurrentLanguageChecker.swift
//  StylistEye
//
//  Created by Michal Severín on 22.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

protocol CurrentLocaleProtocol {
    var languageCode: String {get}
}

extension CurrentLocaleProtocol where Self: RawRepresentable, Self.RawValue == String {
    var languageCode: String {
        return rawValue
    }
}

enum CurrentLanguageChecker: String, CurrentLocaleProtocol {
    
    case english = "en"
    case czech = "cs"
    case slovakie = "sk"
}
