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
    var request: RequestType {get}
    var multipartData: [String: Data] {get}
}

enum RequestType {
    case request
    case upload
}

/**
 Define API url manager.
    - login
    - logout
    - messages
 */
enum APIUrlManager: APIUrlManagerProtocol {

    /**
     GarmentType
     */
    case garmentType
    
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
    case updateMessagesStatus(
        msgId: Int
    )
    case newMessage(
        thread: Int,
        content: String,
        orderId: Int
    )
    case messageDetail(
        orderId: Int?
    )

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
    
    /**
     Dress styles
     */
    case dressStyle
    
    /**
     Upload wardrobe photo
    */
    case uploadWardrobePhoto(id: Int, photoType: Int, photo: Data)
    
    
    
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
            fallthrough
        case .updateMessagesStatus:
            urlString = "/mapi/v1/messages/"
        case let .newMessage(_, _, orderId):
            urlString = "/mapi/v1/messages/\(orderId)"
        case let .messageDetail(id):
            guard let id = id else {
                break
            }
            urlString = "/mapi/v1/messages/\(id)"
        case .outfits:
            urlString = "/mapi/v1/outfits/"
        case let .outfitDetail(outfitId):
            urlString = "/mapi/v1/outfits/\(outfitId)"
        case .stylistList:
            urlString = "/mapi/v1/stylists"
        case .outfitCategory:
            urlString = "/mapi/v1/lists/currentOutfitCat"
        case .garmentType:
            urlString = "/mapi/v1/lists/garmenttypes"
        case .dressStyle:
            urlString = "/mapi/v1/lists/dressstyles"
        case let .uploadWardrobePhoto(id, _, _):
            urlString = "/mapi/v1/photos/wardrobe/\(id)"
        }

        guard let url = URL(string: urlString, relativeTo: baseUrl) else {
            return nil
        }

        if let queryParams = addressParams, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = []
            for (queryName, queryValue) in queryParams {
                let stringValue = String(describing: queryValue)
                urlComponents.queryItems?.append(URLQueryItem(name: queryName, value: stringValue))
            }
            return urlComponents.url?.absoluteString
        }

        return url.absoluteString
    }

    /// GET parameters.
    var addressParams: [String: Any]? {
        guard let token = Keychains[.accessTokenKey] else {
            return [:]
        }
        var params: [String: Any] = [:]
        params["token"] = token
        print("token=\(token)")
        switch self {
        case .login:
            return nil
        case .outfitCategory:
            fallthrough
        case .updateMessagesStatus:
            fallthrough
        case .newMessage:
            return params
        case .logout:
            fallthrough
        case .messages:
            params["expanded"] = "userDetails,lastMessage"
            params["size"] = 100
            return params
        case .messageDetail:
            params["expanded"] = "userDetails"
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
        case .garmentType:
            return params
        case .dressStyle:
            return params
        case .uploadWardrobePhoto:
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
        case let .updateMessagesStatus(
                msgId
            ):
            return [
                "message": "\(msgId)",
                "read": "true",
            ]
        case let .newMessage(
                thread,
                content,
                _
            ):
            return [
                "thread": "\(thread)",
                "content": content,
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
        case .messageDetail:
            fallthrough
        case .outfitCategory:
            fallthrough
        case .garmentType:
            fallthrough
        case .dressStyle:
            return [:]
        case .uploadWardrobePhoto:
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
        case .messageDetail:
            fallthrough
        case .garmentType:
            fallthrough
        case .outfitCategory:
            return .get
        case .updateMessagesStatus:
            return .put
        case .newMessage:
            return .post
        case .dressStyle:
            return .get
        case .uploadWardrobePhoto:
            return .post
        }
    }
    
    var request: RequestType {
        switch self {
        case .uploadWardrobePhoto:
            return .upload
        default:
            return .request
        }
    }
    
    var multipartData: [String : Data] {
        switch self {
        case let .uploadWardrobePhoto(_, photoType, photo):
            return [
                "PhotoType": "\(photoType)".data(using: .ascii)!,
                "file": photo
            ]
        default:
            return [:]
        }
    }
}
