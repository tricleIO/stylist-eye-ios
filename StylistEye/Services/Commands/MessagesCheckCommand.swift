//
//  MessagesCheckCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 03.07.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

struct MessagesCheckCommand: NetworkExecutable {
  
  typealias Data = MessagesCheckDTO
  
  var urlManager: APIUrlManager
  
  init() {
    urlManager = .messagesCheck
  }
}
