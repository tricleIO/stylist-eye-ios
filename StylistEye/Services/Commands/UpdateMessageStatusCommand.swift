//
//  UpdateMessageStatusCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 05.02.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

struct UpdateMessageStatusCommand: NetworkExecutable {
    
    typealias Data = EmptyDTO
    var urlManager: APIUrlManager
    
    init(threadId: Int, msgId: Int) {
        urlManager = .updateMessagesStatus(threadId: threadId, msgId: msgId)
    }
}
