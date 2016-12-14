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
                print(value.objectsArray)
                print(value.errorMessage?.message)
                completion(.success(object: value.objects, objectsArray: value.objectsArray, apiResponse: ApiResponse(code: value.result ?? 0)))
            case .failure:
                print(response.result.value?.errorMessage?.message)
                completion(.failure(message: response.result.value?.errorMessage?.message ?? String.empty, apiResponse: ApiResponse(code: response.result.value?.result ?? 0)))
            }
        }
    }
}
