//
//  UserInfo.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

struct UserInfo {

    var identifier: Int?
    var email: String?
    var firstname: String?
    var surname: String?

    init(userInfo: UserDTO?) {
        identifier = userInfo?.clientId
        email = userInfo?.email
        firstname = userInfo?.firstname
        surname = userInfo?.surname
    }
}

// MARK: - <StaticSerializable>
extension UserInfo: StaticSerializable {

    // MARK: Static Properties
    static let serializableKey = UserDefaults.UserDefaultsKeys.userProfileInfo

    // MARK: Constructor
    init?(dictionary: [String: Any]?) {
        identifier = dictionary?["identifier"] as? Int
        email = dictionary?["email"] as? String
        firstname = dictionary?["firstname"] as? String
        surname = dictionary?["surname"] as? String
    }

    // MARK: Public methods
    func encode() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["identifier"] = identifier
        dictionary["email"] = email
        dictionary["firstname"] = firstname
        dictionary["surname"] = surname
        return dictionary
    }
}
