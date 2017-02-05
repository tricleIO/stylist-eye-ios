//
//  NetworkExecutable.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public enum ApiResponse: Int {

    case fail = 0
    case ok

    init(code: Int) {
        self = ApiResponse(rawValue: code) ?? .fail
    }
}

protocol NetworkExecutable {

    associatedtype Data: Mappable
    var urlManager: APIUrlManager {get}
    func executeCommand(completion: @escaping Completion)
}

// TODO: @MS - reload access token
extension NetworkExecutable {

    typealias Completion = (_ data: NetworkResponse<Data>) -> Swift.Void

    func executeCommand(completion: @escaping Completion) {
        guard let url = urlManager.url else {
            return
        }
        Alamofire.request(url, method: urlManager.method, parameters: urlManager.params, encoding: URLEncoding.methodDependent, headers: nil).responseObject { (response: DataResponse<ObjectResponse<Data>>) in
            switch response.result {
            case let .success(value):
                if let errorMessage = value.errorMessage?.message, errorMessage == "Wrong token. " {
                    self.loginWithExpireToken()
                }
                else {
                    print(value.result)
                    print(value)
                    print(response.response?.statusCode)
                    completion(.success(object: value.objects, objectsArray: value.objectsArray, apiResponse: ApiResponse(code: value.result ?? 0)))
                }
            case .failure:
                completion(.failure(message: response.result.value?.errorMessage?.message ?? String.empty, apiResponse: ApiResponse(code: response.result.value?.result ?? 0)))
            }
        }
    }
    
    fileprivate func loginWithExpireToken() {
        if let email = Keychains[.userEmail], let password = Keychains[.userPassword] {
            LoginCommand(email: email, password: password).executeCommand { data in
                switch data {
                case let .success(object: data, _, apiResponse: apiResponse):
                    // TODO: @MS
                    AccountSessionManager.manager.closeSession()
                    switch apiResponse {
                    case .ok:
                        Keychains[.userEmail] = email
                        Keychains[.userPassword] = password
                        AccountSessionManager.manager.accountSession = AccountSession(response: data)
                        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
                            window.rootViewController = MainTabBarController()
                        }
                    case .fail:
                        break
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
