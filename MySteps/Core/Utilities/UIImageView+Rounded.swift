//
//  UIImageView+Rounded.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

extension UIImageView {
    
    func circleShaped() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
    }
}
