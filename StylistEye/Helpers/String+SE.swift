//
//  String+SE.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation
import UIKit

private protocol StringContainerProtocol {
    var localizedString: String { get }
}

extension String {

    /// Just stop plain text in code.
    static var empty: String {
        return ""
    }
    
    static var space: String {
        return " "
    }
}

extension String {

    var urlValue: URL? {
        guard let url = URL(string: self) else {
            return nil
        }
        return url
    }
}

public var StringContainer = String.empty

extension String {

    internal enum LocalizedTable: String {
        case login
        case main
        case settings
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
        case language
        case languages
        case privacy
        case note
        case about
        case logout
        case menu
        case pants
        case dress
        case jacket
        case shoe
        case shirt
        case cap
        case work
        case bussiness
        case earings
        case messages
        case outfitOverview
        case takePhoto

        var localizedString: String {
            var stringToReturn: String = String.empty
            switch self {
            case .questionnaire:
                stringToReturn = "questionnaire"
            case .outfit:
                stringToReturn = "outfit"
            case .wardrobe:
                stringToReturn = "wardrobe"
            case .language:
                stringToReturn = "language"
            case .languages:
                stringToReturn = "languages"
            case .privacy:
                stringToReturn = "privacy"
            case .note:
                stringToReturn = "note"
            case .about:
                stringToReturn = "about"
            case .logout:
                stringToReturn = "logout"
            case .menu:
                stringToReturn = "menu"
            case .pants:
                stringToReturn = "pants"
            case .dress:
                stringToReturn = "dress"
            case .jacket:
                stringToReturn = "jacket"
            case .shoe:
                stringToReturn = "shoe"
            case .shirt:
                stringToReturn = "shirt"
            case .cap:
                stringToReturn = "cap"
            case .work:
                stringToReturn = "work"
            case .bussiness:
                stringToReturn = "bussiness"
            case .earings:
                stringToReturn = "earings"
            case .messages:
                stringToReturn = "messages"
            case .outfitOverview:
                stringToReturn = "outfit-overview"
            case .takePhoto:
                stringToReturn = "take-photo"
            }
            return stringToReturn
        }
    }

    subscript(main: Main) -> String {
        return "SE-Main-\(main.localizedString.capitalizedFirst)".localizedFromTable(locTable: .main)
    }

    /**
     Settings string file.
     */
    internal enum Settings: StringContainerProtocol {

        case english
        case deutch
        case cestina
        case italy
        case fransais

        var localizedString: String {
            var stringToReturn: String = String.empty
            switch self {
            case .english:
                stringToReturn = "english"
            case .deutch:
                stringToReturn = "deutch"
            case .cestina:
                stringToReturn = "cestina"
            case .italy:
                stringToReturn = "italy"
            case .fransais:
                stringToReturn = "fransais"
            }
            return stringToReturn
        }
    }

    subscript(settings: Settings) -> String {
        return "SE-Settings-\(settings.localizedString.capitalizedFirst)".localizedFromTable(locTable: .settings)
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

    var controllerFromString: UIViewController {
        return UIViewController()
    }
}
