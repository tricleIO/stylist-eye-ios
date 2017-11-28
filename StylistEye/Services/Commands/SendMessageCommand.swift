//
//  SendMessageCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 05.02.17.
//  Copyright © 2017 Michal Severín. All rights reserved.
//

import Foundation

struct SendMessageCommand: NetworkExecutable {
    
    typealias Data = MyMessagesDTO
    var urlManager: APIUrlManager
    
    init(thread: Int, content: String, orderId: Int) {
        urlManager = .newMessage(thread: thread, content: content, orderId: orderId)
    }
}
