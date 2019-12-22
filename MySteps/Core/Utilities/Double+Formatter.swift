//
//  Double + Separator.swift
//  MySteps
//
//  Created by Fernando Frances  on 22/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation

extension Double {
    var stringWithThousendSeparator: Double {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        let number = NSNumber(value: self)
        formatter.string(from: number)
    }
}
