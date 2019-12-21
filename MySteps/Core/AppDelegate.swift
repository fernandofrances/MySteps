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
        
        AppearanceManager.configureAppearance()
        
        let healthKitManager = HealthKitManager()
        let user = User(name: "Neil Armstrong", image: "profile-photo", totalSteps: 0)
        let homePresenter = HomePresenter(healthManager: healthKitManager, user: user)
        let mainViewController = HomeViewController(presenter: homePresenter)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
        
    }


}

