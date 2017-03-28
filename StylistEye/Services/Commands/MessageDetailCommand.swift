//
//  Mess.swift
//  StylistEye
//
//  Created by Michal Severín on 18.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

struct MessagesDetailCommand: NetworkExecutable {
    
    typealias Data = MessagesDTO
    
    var urlManager: APIUrlManager
    
    init(orderId: Int?) {
        urlManager = .messageDetail(orderId: orderId)
    }
}
