//
//  NoAchievementsView.swift
//  MySteps
//
//  Created by Fernando Frances  on 22/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

class NoAchievementsView: UIView, NibLoadableView{

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Strings.noAchievementsTitle.localized
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.text = Strings.noAchievementsSubtitle.localized
        }
    }

}
