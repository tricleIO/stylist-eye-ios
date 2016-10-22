//
//  Messages.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct MessagesDTO: Mappable {

    var msgId: Int?
    var text: String?
    var data: Date?
    var stylistFirstName: String?
    var stylistLastName: String?
    var stylistId: Int?
    var source: Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        msgId <- map["MsgId"]
        text <- map["Text"]
        data <- map["Data"]
        stylistFirstName <- map["StylistFirstName"]
        stylistLastName <- map["StylistLastName"]
        stylistId <- map["StylistId"]
        source <- map["Source"]
    }
}
