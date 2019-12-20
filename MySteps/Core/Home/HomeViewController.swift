//
//  MainViewController.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    private let healthManager: HealthKitManager
    
    init(healthManager: HealthKitManager) {
        self.healthManager = healthManager
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if healthManager.authorized {
            healthManager.requestPermission()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] granted in
                    guard let `self` = self else { return }
                    print(granted ? "🤙🏼 granted!" : "🖕🏻 not granted")
                    self.buildChart()
                }, onError: { _ in
                    print("🤭 some error happened")
                })
        }
        
        
        let header = HeaderView.instantiate()
        stackView.addArrangedSubview(header)
        
    }
    
    private func buildChart() {
        let chart = Chart()
        
        let pointEntries: [PointEntry] = [PointEntry(value: 0, label: "1"),
                                          PointEntry(value: 8800, label: "5"),
                                          PointEntry(value: 2030, label: "10"),
                                          PointEntry(value: 2000, label: "15"),
                                          PointEntry(value: 7000, label: "20"),
                                          PointEntry(value: 0, label: "25"),
                                          PointEntry(value: 1002, label: "30"),
                                          PointEntry(value: 200, label: "1"),
                                          PointEntry(value: 300, label: "5"),
                                          PointEntry(value: 10000, label: "10"),
                                          PointEntry(value: 9000, label: "15"),
                                          PointEntry(value: 9003, label: "20"),
                                          PointEntry(value: 700, label: "25"),
                                          PointEntry(value: 200, label: "1"),
                                          PointEntry(value: 4002, label: "5"),
                                          PointEntry(value: 200, label: "10"),
                                          PointEntry(value: 500, label: "15"),
                                          PointEntry(value: 12223, label: "20"),
                                          PointEntry(value: 700, label: "25"),
                                          PointEntry(value: 200, label: "1"),
                                          PointEntry(value: 300, label: "5"),
                                          PointEntry(value: 200, label: "10"),
                                          PointEntry(value: 500, label: "15"),
                                          PointEntry(value: 600, label: "20"),
                                          PointEntry(value: 0, label: "25"),
                                          PointEntry(value: 200, label: "1"),
                                          PointEntry(value: 300, label: "5"),
                                          PointEntry(value: 0, label: "10"),
                                          PointEntry(value: 500, label: "15"),
                                          PointEntry(value: 600, label: "20"),
                                          PointEntry(value: 700, label: "25")]
        
        chart.dataEntries = pointEntries
        stackView.addArrangedSubview(chart)
    }


}
