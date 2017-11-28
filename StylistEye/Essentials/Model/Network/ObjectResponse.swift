//
//  ResponseObject.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

/**
 Response object is responsible for parsing data from API.
 - Object: Object that will be parsed.
 */
public final class ObjectResponse<Object: Mappable>: Mappable {

    var objects: Object?
    var objectsArray: [Object]?
    var errorMessage: ErrorMEssageDTO?
    var result: Int?
    var pagination: PaginationDTO?

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        objects <- map["data"]
        objectsArray <- map["data"]
        errorMessage <- map["error"]
        result <- map["result"]
        pagination <- map["pagination"]
    }
}

struct ErrorMEssageDTO: Mappable {
    
    var message: String?
    
    public init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
    }
}

