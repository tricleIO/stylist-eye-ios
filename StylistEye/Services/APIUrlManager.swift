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
    var multipartData: ((MultipartFormData) -> Void) {get}
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
     Current Outfits category list.
     */
    case currentOutfitCategories
    
    /**
     Current Outfits.
     */
    case currentOutfits(category: String)
    
    /**
     Current Outfit item detail.
     */
    case currentOutfitDetail(id: Int)
    
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
    case uploadWardrobePhoto(id: Int, photo: Data)
    
    /**
     Upload second wardrobe photo
     */
    case uploadWardrobeSecondPhoto(id: Int, photo: Data)
    
    /**
     Upload outfit photo
     */
    case uploadOutfitPhoto(id: Int, photoType: Int, photo: Data)
    
    /**
     Delete outfit photo
     */
    case deleteOutfitPhoto(id: Int)
    
    /**
     Wardrobe
     */
    case wardrobe(garmetType: Int)
    
    /**
     Wardrobe item
     */
    case wardrobeItem(id: Int)
    
    /**
     Delete wardrobe photo
     */
    case deleteWardrobePhoto(id: Int, type: Int)
    
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
        case .currentOutfitCategories:
            urlString = "/mapi/v1/lists/currentoutfitcat"
        case .currentOutfits:
            urlString = "/mapi/v1/currentoutfits"
        case let .currentOutfitDetail(id):
            urlString = "/mapi/v1/currentoutfits/\(id)"
        case .garmentType:
            urlString = "/mapi/v1/lists/garmenttypes"
        case .dressStyle:
            urlString = "/mapi/v1/lists/dressstyles"
        case let .uploadWardrobePhoto(id, _), let .deleteWardrobePhoto(id, _):
            urlString = "/mapi/v1/photos/wardrobe/\(id)"
        case let .uploadOutfitPhoto(id, _, _), .deleteOutfitPhoto(let id):
            urlString = "/mapi/v1/photos/outfit/\(id)"
        case let .uploadWardrobeSecondPhoto(id, _):
            urlString = "/mapi/v1/photos/wardrobe/photo2/\(id)"
        case .wardrobe:
            urlString = "/mapi/v1/wardrobe"
        case let .wardrobeItem(id):
            urlString = "/mapi/v1/wardrobe/\(id)"
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
        case .currentOutfitCategories:
            return params
        case let .currentOutfits(category):
            params["expanded"] = "photos"
            params["currentCategory"] = category
            return params
        case .currentOutfitDetail:
            params["expanded"] = "photos"
            return params
        case .updateMessagesStatus:
            fallthrough
        case .newMessage:
            return params
        case .logout:
            fallthrough
        case .messages:
            params["expanded"] = "userDetails,lastMessage"
            return params
        case .messageDetail:
            params["expanded"] = "userDetails"
            return params
        case let .outfits(stylistId, dressstyle):
            if let stylistId = stylistId {
                params["stylists"] = stylistId
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
        case .uploadWardrobePhoto, .uploadWardrobeSecondPhoto, .uploadOutfitPhoto, .deleteOutfitPhoto:
            return params
        case let .deleteWardrobePhoto(_, type):
            params["type"] = type
            return params
        case let .wardrobe(garmetType):
            params["garmettype"] = garmetType
            params["expanded"] = "photos,garmentType,reviews"
            return params
        case .wardrobeItem:
            params["expanded"] = "photos,garmentType,reviews"
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
        case .currentOutfitCategories:
            fallthrough
        case .currentOutfits:
            fallthrough
        case .currentOutfitDetail:
            fallthrough
        case .garmentType:
            fallthrough
        case .dressStyle:
            return [:]
        case .uploadWardrobePhoto, .uploadWardrobeSecondPhoto, .uploadOutfitPhoto, .deleteOutfitPhoto, .deleteWardrobePhoto:
            return [:]
        case .wardrobe, .wardrobeItem:
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
        case .currentOutfitCategories, .currentOutfits, .currentOutfitDetail:
            return .get
        case .updateMessagesStatus:
            return .put
        case .newMessage:
            return .post
        case .dressStyle:
            return .get
        case .uploadWardrobePhoto, .uploadWardrobeSecondPhoto, .uploadOutfitPhoto:
            return .post
        case .deleteOutfitPhoto, .deleteWardrobePhoto:
            return .delete
        case .wardrobe:
            return .get
        case .wardrobeItem:
            return .get
        }
    }
    
    var request: RequestType {
        switch self {
        case .uploadWardrobePhoto, .uploadWardrobeSecondPhoto, .uploadOutfitPhoto:
            return .upload
        default:
            return .request
        }
    }
    
    var multipartData: ((MultipartFormData) -> Void) {
        switch self {
        case let .uploadWardrobePhoto(_, photo), let .uploadWardrobeSecondPhoto(_, photo):
            return { multipartFormData in
                multipartFormData.append(photo, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        case let .uploadOutfitPhoto(_, photoType, photo):
            return { multipartFormData in
                multipartFormData.append("\(photoType)".data(using: .utf8)!, withName: "PhotoType")
                multipartFormData.append(photo, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        default:
            return {
                multipartFormData in
            }
        }
    }
    
    
    
}
