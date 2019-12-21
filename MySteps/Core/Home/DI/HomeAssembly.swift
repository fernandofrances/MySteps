//
//  HomeAssembly.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation


final class HomeAssembly {
    public func viewController(user: User) -> HomeViewController {
        return HomeViewController(presenter: presenter(user: user))
    }
    
    private func presenter(user: User) -> HomePresenter {
        return HomePresenter(repository: repository(), user: user)
    }
    
    private func repository() -> HomeRepositoryProtocol {
        return HomeRepository(dataManager: CoreDataManager(), healthManager: HealthKitManager())
    }
}
