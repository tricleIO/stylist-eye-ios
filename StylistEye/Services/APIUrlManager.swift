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
     - Parameters:
     - stylistId
     - dressstyle
     */
    case outfits(
        stylistId: String?,
        dressstyle: String?
    )

    /**
     Oufit detail.
     - Parameters:
        - outfitId
        - photoType
     */
    case outfitDetail (
        outfitId: Int
    )
    
    /**
     Outfits category.
     */
    case outfitCategory
    
    /**
     Stylist list.
     */
    case stylistList
    
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
            urlString = "/mapi/v1/user/logout"
        case .messages:
            urlString = "/mapi/v1/messages"
        case .outfits:
            fallthrough
        case .outfitDetail:
            urlString = "/mapi/v1/outfits/"
        case .stylistList:
            urlString = "/mapi/v1/stylists"
        case .outfitCategory:
            urlString = "/mapi/v1/lists/currentOutfitCat"
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
        guard let token = Keychains[.accessTokenKey] else {
            return [:]
        }
        var params: [String: String] = [:]
        params["token"] = token
        switch self {
        case .login:
            return nil
        case .outfitCategory:
            fallthrough
        case .logout:
            fallthrough
        case .messages:
            return params
        case let .outfits(stylistId, dressstyle):
            if let stylistId = stylistId {
                params["stylist"] = stylistId
            }
            if let dressstyle = dressstyle {
                params["dressstyle"] = dressstyle
            }
            params["expanded"] = "stylistDetails,photos,dressStyle,components"
            return params
        case .stylistList:
            params["expanded"] = "photos"
            return params
        case let .outfitDetail(
            outfitId
            ):
            params["outfit_id"] = String(outfitId)
            params["expanded"] = "stylistDetails,photos,dressStyle,components"
            return params
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
        case .stylistList:
            fallthrough
        case .outfitDetail:
            fallthrough
        case .outfitCategory:
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
            fallthrough
        case .stylistList:
            fallthrough
        case .outfitCategory:
            return .get
        }
    }
}
