//
//  AccountSessionManager.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

final class AccountSessionManager {

    static let manager = AccountSessionManager()

    var accountSession: AccountSession?

    fileprivate init() {
        accountSession = AccountSession()
    }
}
