//
//  AccountSession.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

struct AccountSession {

    var userInfo: UserInfo? {
        didSet {
            guard let userInfo = userInfo else {
                return
            }
            userInfo.save()
        }
    }

    fileprivate mutating func createUser(userInfo: UserInfo?) {
        guard let _ = userInfo else {
            return
        }
    }

    fileprivate var accessToken: AccessToken? {
        willSet {
            guard let _ = newValue else {
                return
            }
        }
    }

    init?() {
        guard let token = AccessToken() else {
            return nil
        }
        accessToken = token
        userInfo = UserInfo.load()
    }

    init?(response: LoginDTO?) {
        guard let token = response?.token else {
            return nil
        }
        accessToken = AccessToken(token: token)
        userInfo = UserInfo(userInfo: response?.user)
        userInfo?.save()
    }
}
