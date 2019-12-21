//
//  Date+Calendar.swift
//  MySteps
//
//  Created by Fernando Frances  on 20/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

