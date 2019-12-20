//
//  HeaderView.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

class HeaderView: UIView, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Strings.headerTitle.localized
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circleShaped()
        }
    }
    @IBOutlet weak var dateIntervalLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    
}
