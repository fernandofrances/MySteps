//
//  DateInterval.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation

struct DateInterval {
    let startDate: Date
    let endDate: Date
    
    var description: String {
       let formatter = DateFormatter()
       formatter.dateFormat = "MMM d"
       let startDateString = formatter.string(from: startDate)
       let endDateString = formatter.string(from: endDate)
       
       formatter.dateFormat = "yyyy"
       let year = formatter.string(from: endDate)
       
       return  "\(startDateString)-\(endDateString) \(year)"
    }
}


enum TimePeriod {
    case lastThirtyDays
}

extension TimePeriod {
    
    private func dayDateInterval(from date: Date?) -> DateInterval? {
        guard let startOfDay = date?.startOfDay, let endOfDay = date?.endOfDay else { return nil }
        return DateInterval(startDate: startOfDay, endDate: endOfDay)
    }
    
    var dateIntervals: [DateInterval] {
        switch self {
        case .lastThirtyDays:
              return Array(0...30)
                  .compactMap {
                    let day = Calendar.current.date(byAdding: .day, value: -$0, to: Date())
                    return dayDateInterval(from: day)
                  }
                  .reversed()
        }
    }
        
}
