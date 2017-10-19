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
    var order: OrderDTO?
    var counterparty: AuthorDTO?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        messagesCount <- map["messageCount"]
        lastMessage <- map["lastMessage"]
        order <- map["order"]
        counterparty <- map["counterparty"]
    }
}

struct MessagesDTO: Mappable {

    var messagesCount: Int?
    var messages: [MyMessagesDTO] = []
    var order: OrderDTO?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        messagesCount <- map["messageCount"]
        messages <- map["messages"]
        order <- map["order"]
    }
}

struct MyMessagesDTO: Mappable {
    
    var identifier: Int
    var author: AuthorDTO?
    var content: String?
    var timestamp: Date?
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
        timestamp <- (map["timestamp"], DateTimeTransform(.iso8601Date))
        read <- map["read"]
        systemOriginate <- map["systemOriginate"]
    }
}

struct LastMessagesDTO: Mappable {
    
    var identifier: Int
    var author: AuthorDTO?
    var content: String?
    var timestamp: Date?
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
        timestamp <- (map["timestamp"], DateTimeTransform(.iso8601Date))
        read <- map["read"]
        systemOriginate <- map["systemOriginate"]
    }
}


struct OrderDTO: Mappable {
    
    var identifier: Int?
    
    init?(map: Map) {
        var id: Int?
        id <- map["id"]
        guard let identifier = id else {
            return nil
        }
        self.identifier = identifier
    }
    
    mutating func mapping(map: Map) {
    }
}
