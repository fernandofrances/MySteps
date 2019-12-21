//
//  StepsView.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

final class StepsView: UIView, NibLoadableView {

    @IBOutlet weak var chart: Chart!
    
    func configure(with dataPoints: [PointEntry]) {
        chart.dataEntries = dataPoints
    }
    
}
