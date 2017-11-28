//
//  LoginCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Login command.
 */
struct LoginCommand: NetworkExecutable {

    /// Login DTO
    typealias Data = LoginDTO

    /// Url manager.
    var urlManager: APIUrlManager

    init(email: String, password: String) {
        urlManager = .login(email: email, password: password)
    }
}
