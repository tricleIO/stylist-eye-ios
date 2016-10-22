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
        Alamofire.request(url, method: urlManager.method, parameters: urlManager.params, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<ObjectResponse<Data>>) in

            switch response.result {
            case let .success(value):
                switch response.result.value?.errorMessage {
                // TODO: @MS
                case "Wrong token. "?:
                    guard let email = Keychains[.userEmail], let password = Keychains[.userPassword] else {
                        return
                    }
                    AccountSessionManager.manager.closeSession()
                    let loginUrlManager = LoginCommand(email: email, password: password).urlManager
                    guard let loginUrl = loginUrlManager.url else {
                        return
                    }
                    Alamofire.request(loginUrl, method: loginUrlManager.method, parameters: loginUrlManager.params, encoding: URLEncoding.default, headers: nil).responseObject { (response2: DataResponse<ObjectResponse<UserDTO>>) in
                        switch response2.result {
                        case let .success(value2):
                            AccountSessionManager.manager.accountSession = AccountSession(response: value2.objects)
                            guard let lastCommandUrl = self.urlManager.url else {
                                return
                            }
                            Alamofire.request(lastCommandUrl, method: self.urlManager.method, parameters: self.urlManager.params, encoding: URLEncoding.default, headers: nil).responseObject { (lastResponse: DataResponse<ObjectResponse<Data>>) in

                                print("rofl")
                                print(lastResponse.result)
                                print(lastResponse.result.value)
                                print(lastResponse.result.value?.objects)
                                print(lastResponse.result.value?.objectsArray)

                                switch lastResponse.result {
                                case let .success(lastValue):
                                    completion(.success(object: lastValue.objects, objectsArray: lastValue.objectsArray, apiResponse: ApiResponse(code: lastResponse.result.value?.statusCode ?? 0)))
                                case .failure:
                                    completion(.failure(message: lastResponse.result.value?.errorMessage ?? String.empty, apiResponse: ApiResponse(code: lastResponse.result.value?.statusCode ?? 0)))
                                }
                            }
                        case .failure:
                            completion(.failure(message: response.result.value?.errorMessage ?? String.empty, apiResponse: ApiResponse(code: response.result.value?.statusCode ?? 0)))
                        }
                    }
                default:
                   completion(.success(object: value.objects, objectsArray: value.objectsArray, apiResponse: ApiResponse(code: response.result.value?.statusCode ?? 0)))
                }
            case .failure:
                completion(.failure(message: response.result.value?.errorMessage ?? String.empty, apiResponse: ApiResponse(code: response.result.value?.statusCode ?? 0)))
            }
        }
    }
}
