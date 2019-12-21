//
//  HomeRepository.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeRepository: ReactiveCompatible {
    
    let dataManager: CoreDataManager
    let healthManager: HealthKitManager
    
    fileprivate var stepCount = BehaviorRelay<Double>(value: 0)
    
    private lazy var calendar: Calendar = { return Calendar.current }()
    
    init(dataManager: CoreDataManager, healthManager: HealthKitManager) {
        self.dataManager = dataManager
        self.healthManager = healthManager
    }
    
    func createUserInPersistanceStore(_ user: User) {
        dataManager.createUserData(user)
     }
     
     func updateUserStepsInPersistanceStore(_ steps: Double) {
        dataManager.updateUserSteps(steps)
        stepCount.accept(getUserStepsFromPersistanceStore())
     }
     
     private func getUserStepsFromPersistanceStore() -> Double {
         return dataManager.getUserSteps()
     }
    
    func loadStepData() -> Observable<[PointEntry]> {
       if !healthManager.authorized { return Observable.error(RxError.unknown) }
       return healthManager.requestPermission()
       .flatMap { [weak self] granted -> Observable<[StepsData]> in
            guard let `self` = self, granted else { return Observable.error(RxError.unknown) }
            return self.healthManager.getSteps(for: self.dateIntervals())
       }
       .map { stepData in
        return stepData.map { step in
            return PointEntry(value: Int(step.stepCount),
                              label: String(self.calendar.component(.day,from: step.day)))
        }
       }
      
    }
    
    func dateIntervals() -> [DateInterval] {
        return Array(0...30)
        .compactMap {
            let day = self.calendar.date(byAdding: .day, value: -$0, to: Date())
            guard let startOfDay = day?.startOfDay, let endOfDay = day?.endOfDay else { return nil }
            return DateInterval(startDate: startOfDay, endDate: endOfDay)
        }
        .reversed()
     }
    
}

extension Reactive where Base: HomeRepository {
    var stepCount: Observable<Double> {
        return base.stepCount.asObservable()
    }
}
