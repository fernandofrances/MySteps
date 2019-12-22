//
//  AchievementCell.swift
//  MySteps
//
//  Created by Fernando Frances  on 22/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

class AchievementCell: UICollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Strings.achievementItemTitle.localized
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circleShaped()
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func configure(with achievement: Achievement) {
        subtitleLabel.text = achievement.title
        imageView.image = UIImage(named: achievement.icon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
