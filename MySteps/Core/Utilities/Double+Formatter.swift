//
//  Double + Separator.swift
//  MySteps
//
//  Created by Fernando Frances  on 22/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation

extension Double {
    var stringWithThousendSeparator: String? {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        let number = NSNumber(value: Int(self))
        return formatter.string(from: number)
    }
    
    var stringWithKForThousends: String? {
        if !(self > 1000) { return nil }
        var numberString = String(Int(self))
        for _ in 0...2 {
            numberString.removeLast()
        }
        return numberString + "K"
    }
}
