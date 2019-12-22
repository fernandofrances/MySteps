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
    
    func loadStepData(timePeriod: TimePeriod) -> Observable<([PointEntry], Double)> {
        
       if !healthManager.authorized { return Observable.error(RxError.unknown) }
       return healthManager.requestPermission()
       .flatMap { [weak self] granted -> Observable<[StepsData]> in
            guard let `self` = self, granted else { return Observable.error(RxError.unknown) }
            return self.healthManager.getSteps(for: timePeriod.dateIntervals)
       }
       .map { stepData in
            let pointEntries = stepData.map { step in
                return PointEntry(value: Int(step.stepCount),
                                  label: String(self.calendar.component(.day,from: step.day)))
            }
            
            let totalStepCount = pointEntries.reduce(0) { result, point in
                return result + Double(point.value)
            }
            
            return (pointEntries, totalStepCount)
       }
      
    }
    
}

extension Reactive where Base: HomeRepository {
    var stepCount: Observable<Double> {
        return base.stepCount.asObservable()
    }
}
