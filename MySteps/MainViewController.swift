//
//  MainViewController.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
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
                .subscribe(onNext: { granted in
                    print(granted ? "🤙🏼 granted!" : "🖕🏻 not granted")
                }, onError: { _ in
                    print("🤭 some error happened")
                })
        } 
    }



}
