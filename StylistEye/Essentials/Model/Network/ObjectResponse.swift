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
    var errorMessage: String?
    var statusCode: Int?

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        objects <- map["Data"]
        errorMessage <- map["errorMessage"]
        statusCode <- map["Result"]
    }
}
