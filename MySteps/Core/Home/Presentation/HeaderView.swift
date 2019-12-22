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
    
    func configure(with user: User, timePeriod: TimePeriod) {
        imageView.image = UIImage(named: user.image)
        stepCountLabel.text = String(user.totalSteps)
        updateTimePeriodLabel(timePeriod)
     
    }
    
    func updateTimePeriodLabel(_ timePeriod: TimePeriod) {
        guard let start = timePeriod.dateIntervals.first?.startDate,
                 let end = timePeriod.dateIntervals.last?.startDate else { return }
             let interval = DateInterval(startDate: start, endDate: end)
             dateIntervalLabel.text = interval.description
    }
 
    
}
