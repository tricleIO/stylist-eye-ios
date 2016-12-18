//
//  TimeHelper.swift
//  StylistEye
//
//  Created by Michal Severín on 18.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Predefined timeformatters.
 - CZDate
 - DateTime
 - DateTimeLog
 - Iso8601Date
 - TimeShort
 */
public enum TimeFormatsEnum {
    
    /// yyyy-MM-dd
    case usDate
    /// dd.MM.yyyy
    case czDate
    /// yyyy-MM-dd HH:mm:ss
    case dateTime
    /// yyyy-MM-dd HH:mm:ss.SSS
    case dateTimeLog
    /// yyyy-MM-dd'T'HH:mm:ss
    case iso8601Date
    /// "HH:mm"
    case timeShort
    
    fileprivate var formatString: String {
        switch self {
        case .usDate:
            return "yyyy-MM-dd"
        case .czDate:
            return "dd.MM.yyyy"
        case .dateTime:
            return "yyyy-MM-dd HH:mm:ss"
        case .dateTimeLog:
            return "yyyy-MM-dd HH:mm:ss.SSS"
        case .iso8601Date:
            return "yyyy-MM-dd'T'HH:mm:ss"
        case .timeShort:
            return "HH:mm"
        }
    }
    
    fileprivate var formatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        dateFormatter.locale = Locale(identifier: "cs_CZ")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }
    
    /**
     Returns a date representation of a given string.
     - Parameter dateString: The string to parse.
     - Returns: A date representation of string. If dateFromString: can not parse the string, returns nil.
     */
    public func dateFromString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        
        return formatter.date(from: dateString)
    }
    
    /**
     Returns a string representation of a given date.
     - Parameter optionalDate: The date to format.
     - Returns: A string representation of date formatted. If date is nil, returns nil value.
     */
    public func stringFromDate(_ optionalDate: Date?) -> String? {
        guard let date = optionalDate else {
            return nil
        }
        
        return formatter.string(from: date)
    }
    
    /**
     Returns a string representation of a given date.
     - Parameter optionalDate: The date to format.
     - Returns: A string representation of date formatted.
     */
    public func stringFromDate(_ date: Date) -> String {
        return formatter.string(from: date)
    }
}

// MARK: - Date extension
extension Date {
    
    static func tomorrow() -> Date {
        return Date().addingTimeInterval(60*60*24)
    }
    
    static func yesterday() -> Date {
        return Date().addingTimeInterval(-60*60*24)
    }
    
    func isToday(_ timezone: TimeZone = TimeZone(abbreviation: "CET")! as TimeZone) -> Bool {
        return isSameDate(Date(), timezone: timezone)
    }
    
    func isTomorrow(_ timezone: TimeZone = TimeZone(abbreviation: "CET")! as TimeZone) -> Bool {
        return isSameDate(Date.tomorrow(), timezone: timezone)
    }
    
    func isYesterday(_ timezone: TimeZone = TimeZone(abbreviation: "CET")! as TimeZone) -> Bool {
        return isSameDate(Date.yesterday(), timezone: timezone)
    }
    
    func isSameDate(_ compareDate: Date, timezone: TimeZone = TimeZone(abbreviation: "CET")! as TimeZone) -> Bool {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = timezone
        let firstDate = cal.startOfDay(for: compareDate)
        let secondDate = cal.startOfDay(for: self)
        
        return firstDate.compare(secondDate) == .orderedSame
    }
}

// MARK: - Date comparision
/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is earlier than the second one. False otherwise.
 */
public func < (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedDescending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is earlier or same as the second one. False otherwise.
 */
public func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != ComparisonResult.orderedAscending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is later than the second one. False otherwise.
 */
public func > (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedAscending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is later or equal as the second one. False otherwise.
 */
public func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != ComparisonResult.orderedDescending
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is equal to the second one. False otherwise.
 */
public func == (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedSame
}

/**
 Compares two Dates
 - Parameters:
 - lhs: First date
 - rhs: Second date
 - Returns: True if the first date is different than the second one. False otherwise.
 */
public func != (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != ComparisonResult.orderedSame
}
