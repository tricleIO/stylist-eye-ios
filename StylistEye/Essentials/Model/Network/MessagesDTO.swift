//
//  Messages.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct MessagesListDTO: Mappable {
    
    var messagesCount: Int?
    var lastMessage: LastMessagesDTO?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        messagesCount <- map["messageCount"]
        lastMessage <- map["lastMessage"]
    }
}

struct MessagesDTO: Mappable {

    var messagesCount: Int?
    var messages: [MyMessagesDTO] = []
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        messagesCount <- map["messageCount"]
        messages <- map["messages"]
    }
}

struct MyMessagesDTO: Mappable {
    
    var identifier: Int
    var author: AuthorDTO?
    var content: String?
    var timestamp: String? // TODO
    var read: Bool?
    var systemOriginate: Bool?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let identifier = id else {
            return nil
        }
        self.identifier = identifier
    }
    
    mutating func mapping(map: Map) {
        author <- map["author"]
        content <- map["content"]
        timestamp <- map["timestamp"]
        read <- map["read"]
        systemOriginate <- map["systemOriginate"]
    }
}

struct LastMessagesDTO: Mappable {
    
    var identifier: Int
    var author: AuthorDTO?
    var content: String?
    var timestamp: String? // TODO
    var read: Bool?
    var systemOriginate: Bool?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let identifier = id else {
            return nil
        }
        self.identifier = identifier
    }
    
    mutating func mapping(map: Map) {
        author <- map["author"]
        content <- map["contnet"]
        timestamp <- map["timeStamp"]
        read <- map["read"]
        systemOriginate <- map["systemOriginate"]
    }
}



