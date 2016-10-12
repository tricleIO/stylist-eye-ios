//
//  String+SE.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

private protocol StringContainerProtocol {
    var localizedString: String { get }
}

extension String {

    /// Just stop plain text in code.
    static var empty: String {
        return ""
    }
}

public var StringContainer = String.empty

extension String {

    internal enum Login: StringContainerProtocol {

        case email
        case forgotPassword
        case login
        case password

        var localizedString: String {
            var stringToReturn: String = String.empty
            switch self {
            case .email:
                stringToReturn = "email"
            case .forgotPassword:
                stringToReturn = "forgotpassword"
            case .login:
                stringToReturn = "login"
            case .password:
                stringToReturn = "password"
            }
            return stringToReturn
        }
    }

    internal enum LocalizedTable: String {
        case login
    }

    subscript(login: Login) -> String {
        return "SE-Login-\(login.localizedString.capitalizedFirst)".localizedFromTable(locTable: .login)

    }

    /**
     Localize a string from selected table.
     */
    func localizedFromTable(locTable: LocalizedTable) -> String {
        return NSLocalizedString(self, tableName: locTable.rawValue.capitalizedFirst, comment: String.empty)
    }

    var capitalizedFirst: String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst()).lowercased()
        return first + other
    }
}
