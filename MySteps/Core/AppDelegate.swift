//
//  AppDelegate.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = HomeViewController(healthManager: HealthKitManager())
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        return true
        
    }

}

