//
//  GarmentTypeDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 19.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct GarmentTypeDTO: Mappable {

    var typeId: Int?
    var languageId: Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

    }
}


protocol LanguageProtocol {

}

extension LanguageProtocol where Self: RawRepresentable, Self.RawValue == String {

}

enum Languages: String, LanguageProtocol {

    case czech = "cs"
    case english = "en"
 
    init(language: String) {
        self = Languages(rawValue: language) ?? .english
    }
}
