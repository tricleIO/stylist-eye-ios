//
//  Arra.swift
//  StylistEye
//
//  Created by Michal Severín on 14.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

extension Array {

    subscript(safe index: Int) -> Element? {
        if index < self.count && self.count > 0 {
            return self[index]
        }
        else {
            return nil
        }
    }
}
