//
//  Languages.swift
//  StylistEye
//
//  Created by Martin Stachon on 24.03.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

protocol LanguageProtocol {
}

extension LanguageProtocol where Self: RawRepresentable, Self.RawValue == String {
}

enum Languages: Int, LanguageProtocol {
  
  case czech = 1
  case english = 2
  case slovak = 3
  case unknown = 4
  
  init(language: Int) {
    self = Languages(rawValue: language) ?? .english
  }
}
