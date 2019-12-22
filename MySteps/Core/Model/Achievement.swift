//
//  Achievement.swift
//  MySteps
//
//  Created by Fernando Frances  on 20/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation
import RxDataSources

enum Achievement: Double, IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        return String(self.rawValue)
    }
    
    case tenK = 10000
    case fithfteenK = 15000
    case twentyK = 20000
    case twentyFiveK = 25000
    case thirtyK = 30000
    case thirtyFiveK = 35000
    case fortyK = 40000
}


extension Achievement {
    
    var icon: String {
        switch self {
        case .tenK:
            return "10k"
        case .fithfteenK:
            return "15k"
        case .twentyK:
            return "20k"
        case .twentyFiveK:
            return "25k"
        case .thirtyK:
            return "30k"
        case .thirtyFiveK:
            return "35k"
        case .fortyK:
            return "40k"
        }
    }
    
    var title: String? {
        return self.rawValue.stringWithKForThousends
    }
}





