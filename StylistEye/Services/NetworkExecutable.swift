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

protocol NetworkExecutable {

    associatedtype Data: Mappable
    var urlManager: APIUrlManager {get}
    func executeCommand(completion: @escaping Completion)
}

extension NetworkExecutable {

    typealias Completion = (_ data: NetworkResponse<Data>) -> Swift.Void

    func executeCommand(completion: @escaping Completion) {
        Alamofire.request(urlManager.url, method: urlManager.method, parameters: urlManager.params, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<ObjectResponse<Data>>) in

            switch response.result {
            case let .success(value):
                completion(.success(object: value.objects, statusCode: response.result.value?.statusCode))
            case .failure:
                completion(.failure(message: response.result.value?.errorMessage ?? String.empty, statusCode: response.response?.statusCode))
            }
        }
    }
}
