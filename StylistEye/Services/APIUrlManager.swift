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
    var url: String {get}
    var params: [String: String] {get}
    var method: HTTPMethod {get}
}

/**
 Define API url manager.
    - login
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

    /// Url path.
    var url: String {
        var urlString: String = String.empty
        switch self {
        case let .login(
            email,
            password
            ):
            urlString = "/api/MobileAccount/login?userName=\(email)&password=\(password)"
        }
        return "\(APIConfiguration.baseUrl)\(urlString)"
    }

    /// Url parameters.
    var params: [String : String] {
        switch self {
        case .login:
            return [:]
        }
    }

    /// Alamofire/Url method.
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        }
    }
}
