//
//  UserDefauls.swift
//  StylistEye
//
//  Created by Michal Severín on 12.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

public let Defaults = UserDefaults.standard
extension UserDefaults {

    struct Proxy {

        fileprivate let defaults: UserDefaults
        fileprivate let key: String

        fileprivate init(_ defaults: UserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }

        /// Returns the Boolean value associated with the specified key.
        var bool: Bool? {
            if exists {
                if object is Bool {
                    return defaults.bool(forKey: key)
                }
            }
            return nil
        }

        /// Returns the NSData value associated with the specified key.
        var data: Data? {
            if object is NSData {
                return defaults.data(forKey: key)
            }
            return nil
        }

        /// Returns the Date value associated with the specified key.
        var date: Date? {
            return object as? Date
        }

        /// Returns the Double value associated with the specified key.
        var double: Double? {
            if exists {
                if object is Double {
                    return defaults.double(forKey: key)
                }
            }
            return nil
        }

        /// Returns the floating-point value associated with the specified key.
        var float: Float? {
            if exists {
                if object is Float {
                    return defaults.float(forKey: key)
                }
            }
            return nil
        }

        /// Returns the Integer value associated with the specified key.
        var int: Int? {
            if exists {
                switch object {
                case let intValue as Int:
                    return intValue
                case let doubleValue as Double:
                    return Int(doubleValue)
                case let floatValue as Float:
                    return Int(floatValue)
                case let boolValue as Bool:
                    return boolValue ? 1 : 0
                case let stringValue as String:
                    return Int(stringValue)
                default:
                    break
                }
            }
            return nil
        }

        /// Returns the object associated with the first occurrence of the specified default.
        var object: NSObject? {
            return defaults.object(forKey: key) as? NSObject
        }

        /// Returns the string associated with the specified key.
        var string: String? {
            if let numberValue = object as? NSNumber ,
                String(describing: Mirror(reflecting: numberValue).subjectType) == "__NSCFBoolean" {
                return String(numberValue.boolValue)
            }
            return defaults.string(forKey: key)
        }

        /// Returns the array of strings associated with the specified key.
        var stringArray: [String]? {
            if exists {
                if object is Float {
                    return defaults.stringArray(forKey: key)
                }
            }
            return nil
        }

        /// Returns the NSURL instance associated with the specified key.
        var url: URL? {
            if exists {
                if let data = object as? Data {
                    let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: data)
                    if let url = unarchivedObject as? URL {
                        return url
                    }
                }
            }
            return nil
        }

        /// Checks if the value of the specified default key exists.
        var exists: Bool {
            return defaults.object(forKey: key) != nil
        }

        /// Removes the value of the specified default key in the standard application domain.
        func remove() {
            defaults.removeObject(forKey: key)
        }
    }

    func hasKey(_ key: String) -> Bool {
        return object(forKey: key) != nil
    }

    subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }

    subscript(key: String) -> Any? {
        get {
            return self[key]
        }
        set {
            switch newValue {
            case let v as Double:
                set(v, forKey: key)
            case let v as Float:
                set(v, forKey: key)
            case let v as Int:
                set(v, forKey: key)
            case let v as Bool:
                set(v, forKey: key)
            case let v as URL:
                set(v, forKey: key)
            case let v as String:
                set(v, forKey: key)
            case let v as Data:
                set(v, forKey: key)
            case let v as NSObject:
                set(v, forKey: key)
            case nil:
                removeObject(forKey: key)
            default:
                assertionFailure("Invalid value type")
            }
            synchronize()
        }
    }

    // MARK: - UserDefaultsKeys Wrapper
    func hasKey(_ userDefaultsKey: UserDefaultsKeys) -> Bool {
        return hasKey(userDefaultsKey.key)
    }

    subscript(userDefaultsKey: UserDefaultsKeys) -> Proxy {
        return self[userDefaultsKey.key]
    }

    subscript(userDefaultsKey: UserDefaultsKeys) -> Any? {
        get {
            return self[userDefaultsKey.key]
        }
        set {
            self[userDefaultsKey.key] = newValue
        }
    }
}

extension UserDefaults.UserDefaultsKeys {

    /**
     Executes <code>firstRun</code> block and set key to <code>true</code> when never executed. Otherwise executes <code>otherwise</code> block.
     - Parameters:
     - firstRun: The block to execute when User Default key is not set.
     - otherwise: The block to execute when User Default key is already set.
     */
    func run(firstRun: VoidBlock? = nil, otherwise: VoidBlock? = nil) {
        if Defaults[self].bool == true {
            otherwise?()
        }
        else {
            Defaults[self] = true
            firstRun?()
        }
    }

    func run(_ block: VoidBlock) {
        if Defaults[self].bool != true {
            block()
        }
    }
}
