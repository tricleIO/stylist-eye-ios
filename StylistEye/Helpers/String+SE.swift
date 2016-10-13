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

    internal enum LocalizedTable: String {
        case login
        case main
    }

    /**
     Login string file.
     */
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

    subscript(login: Login) -> String {
        return "SE-Login-\(login.localizedString.capitalizedFirst)".localizedFromTable(locTable: .login)

    }

    /**
     Main string file.
     */
    internal enum Main: StringContainerProtocol {

        case questionnaire
        case outfit
        case wardrobe

        var localizedString: String {
            var stringToReturn: String = String.empty
            switch self {
            case .questionnaire:
                stringToReturn = "questionnaire"
            case .outfit:
                stringToReturn = "outfit"
            case .wardrobe:
                stringToReturn = "wardrobe"
            }
            return stringToReturn
        }
    }

    subscript(main: Main) -> String {
        return "SE-Main-\(main.localizedString.capitalizedFirst)".localizedFromTable(locTable: .main)

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
