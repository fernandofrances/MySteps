//
//  LocalizedStrings.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation


enum Strings: String {
    case headerTitle
    case achievementsSectionTitle
    case achievementItemTitle
    
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}



