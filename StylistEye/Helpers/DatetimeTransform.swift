//
//  DatetimeTransform.swift
//  StylistEye
//
//  Created by Michal Severín on 18.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import ObjectMapper

struct DateTimeTransform: TransformType {
    
    typealias Object = Date
    typealias JSON = String
    
    let timeFormat: TimeFormatsEnum
    
    init(_ timeFormat: TimeFormatsEnum = TimeFormatsEnum.usDate) {
        self.timeFormat = timeFormat
    }
    
    func transformFromJSON(_ value: Any?) -> Date? {
        if let timeString = value as? String {
            return timeFormat.dateFromString(timeString)
        }
        return nil
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return timeFormat.stringFromDate(date)
        }
        return nil
    }
}
