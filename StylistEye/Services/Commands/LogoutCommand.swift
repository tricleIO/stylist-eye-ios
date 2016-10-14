//
//  LogoutCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 13.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Logout command.
 */
struct LogoutCommand: NetworkExecutable {

    /// User profile DTO
    typealias Data = EmptyDTO

    /// Url manager.
    var urlManager: APIUrlManager

    init() {
        urlManager = .logout
    }
}
