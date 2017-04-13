//
//  NetworkResponse.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

/**
 This enum watching over result.
 */
public enum NetworkResponse<Data: Mappable> {

    case success(object: Data?, objectsArray: [Data]?, pagination: PaginationDTO?, apiResponse: ApiResponse)
    case failure(message: String, apiResponse: ApiResponse)
}
