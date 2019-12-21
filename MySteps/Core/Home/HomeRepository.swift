//
//  HomeRepository.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation

protocol HomeRepositoryProtocol {
    func createUser(_ user: User)
    func updateUserSteps(_ steps: Double)
    func getUserSteps() -> Double

}

final class HomeRepository: HomeRepositoryProtocol {
    
    let dataManager: CoreDataManager
    
    init(dataManager: CoreDataManager) {
        self.dataManager = dataManager
    }
    
    func createUser(_ user: User) {
        dataManager.createUserData(user)
     }
     
     func updateUserSteps(_ steps: Double) {
        dataManager.updateUserSteps(steps)
     }
     
     func getUserSteps() -> Double {
         return dataManager.getUserSteps()
     }
    
    
}
