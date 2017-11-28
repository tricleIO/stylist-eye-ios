//
//  MessagesCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

struct MessagesCommand: NetworkExecutable {

    typealias Data = MessagesListDTO
    var urlManager: APIUrlManager

    init() {
        urlManager = .messages
    }
}
