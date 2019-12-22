//
//  StepsView.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class StepsView: UIView, NibLoadableView {

    @IBOutlet weak var chart: Chart!
    
    let tap: PublishSubject<Void> = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .map { _ in () }
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
    
    func configure(with dataPoints: [PointEntry]) {
        chart.dataEntries = dataPoints
    }
    
  
    
}

