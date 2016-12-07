//
//  APIUrlManager.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Alamofire

/**
 Api url manager protocol.
 */
protocol APIUrlManagerProtocol {
    var url: String? {get}
    var params: [String: Any] {get}
    var method: HTTPMethod {get}
}

/**
 Define API url manager.
    - login
    - logout
    - messages
 */
enum APIUrlManager: APIUrlManagerProtocol {

    /**
     Login
     - Parameters:
        - userName: User name.
        - password: User password.
     */
    case login(
        email: String,
        password: String
    )

    /**
     Logout
     - Parameters:
        - token: User token.
     */
    case logout

    /**
    Messages
     */
    case messages

    /**
     Outfits
     */
    case outfits

    /**
     Oufit detail.
     - Parameters:
        - outfitId
        - photoType
     */
    case outfitDetail (
        outfitId: Int,
        photoType: Int
    )

    /// Url path.
    var url: String? {
        var baseUrl: URL? {
            return URL(string: APIConfiguration.BaseUrl)
        }

        var urlString: String = String.empty
        switch self {
        case .login:
            urlString = "/mapi/v1/user/login"
        case .logout:
            urlString = "/mapi/MobileAccount/logout"
        case .messages:
            urlString = "/mapi/v1/messages"
        case .outfits:
            urlString = "/mapi/MobileOutfit/outfits"
        case .outfitDetail:
            urlString = "/mapi/MobileOutfit/outfitphotos"
        }

        guard let url = URL(string: urlString, relativeTo: baseUrl) else {
            return nil
        }

        if let queryParams = addressParams, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = []
            for (queryName, queryValue) in queryParams {
                let stringValue = String(queryValue)
                urlComponents.queryItems?.append(URLQueryItem(name: queryName, value: stringValue))
            }
            return urlComponents.url?.absoluteString
        }

        return url.absoluteString
    }

    /// GET parameters.
    var addressParams: [String: String]? {
        switch self {
        case .login:
            return nil
        case .logout:
            fallthrough
        case .messages:
            fallthrough
        case .outfits:
            return [
                "token": Keychains[.accessTokenKey].forcedValue,
                "clientId": Keychains[.clientId].forcedValue,
            ]
        case let .outfitDetail(
            outfitId,
            photoType
            ):
            return [
                "token": Keychains[.accessTokenKey].forcedValue,
                "clientId": Keychains[.clientId].forcedValue,
                "outfitId": "\(outfitId)",
                "photoType": "\(photoType)"
            ]
        }
    }

    /// Url parameters.
    var params: [String : Any] {
        switch self {
        case let .login(
            email,
            password
            ):
            return [
                "email": "\(email)",
                "password": "\(password)",
            ]
        case .logout:
            fallthrough
        case .messages:
            fallthrough
        case .outfits:
            fallthrough
        case .outfitDetail:
            return [:]
        }
    }

    /// Alamofire/Url method.
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .logout:
            fallthrough
        case .messages:
            fallthrough
        case .outfits:
            fallthrough
        case .outfitDetail:
            return .get
        }
    }
}
