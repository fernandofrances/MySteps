//
//  HeaderView.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

final class HeaderView: UIView, NibLoadableView {

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
    
    func configure(with user: User, dateInterval: DateInterval) {
        imageView.image = UIImage(named: user.image)
        stepCountLabel.text = String(user.totalSteps)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        let startDateString = formatter.string(from: dateInterval.startDate)
        let endDateString = formatter.string(from: dateInterval.endDate)
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: dateInterval.endDate)
        
        dateIntervalLabel.text = "\(startDateString) \(endDateString) \(year)"
    }
    
}
