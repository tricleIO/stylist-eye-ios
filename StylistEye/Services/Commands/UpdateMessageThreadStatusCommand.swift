//
//  UpdateMessageThreadStatusCommand.swift
//  StylistEye
//
//  Created by Martin Stachon on 12.09.17.
//  Copyright © 2017 Westico. All rights reserved.
//

import Foundation

struct UpdateMessageThreadStatusCommand: NetworkExecutable {
  
  typealias Data = EmptyDTO
  var urlManager: APIUrlManager
  
  init(threadId: Int) {
    urlManager = .updateMessageThreadStatus(threadId: threadId)
  }
}
