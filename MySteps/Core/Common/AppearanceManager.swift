//
//  AppearanceManager.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit

class AppearanceManager {
    static func configureAppearance() {
        configureNavigationBar()
    }
    
    private static func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.backgroundColor
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                       .font: UIFont.boldSystemFont(ofSize: 14)]
        navigationBarAppearance.isTranslucent = false
    }

}
