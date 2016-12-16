//
//  UserDTO.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

/**
 This struct contains all information about user include token.
 */
struct UserDTO: Mappable {

    var firstname: String?
    var surname: String?
    var email: String?
    var clientId: Int?
    var atavar: UserAvatarDTO?

    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let userId = id else {
            return nil
        }
        clientId = userId
    }

    mutating func mapping(map: Map) {
        firstname <- map["givenName"]
        email <- map["email"]
        surname <- map["familyName"]
        atavar <- map["atavar"]
    }
}

struct UserAvatarDTO: Mappable {
    
    var image: AvatarImageDTO?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        image <- map["image"]
    }
}

struct AvatarImageDTO: Mappable {
    
    var image: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        image <- map["src"]
    }
}

struct LoginDTO: Mappable {
    
    var token: String
    var expiration: Date?
    var lastLogin: Date?
    var user: UserDTO?
    
    init?(map: Map) {
        var accessToken: String?
        accessToken <- map["token"]
        guard let ret = accessToken else {
            return nil
        }
        token = ret
    }
    
    mutating func mapping(map: Map) {
        expiration <- map["expiration"]
        lastLogin <- map["lastLogin"]
        user <- map["user"]
    }
}
