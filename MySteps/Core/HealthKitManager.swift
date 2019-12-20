//
//  HealthKitManager.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation
import HealthKit
import RxSwift

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    lazy var calendar: Calendar = {
        return Calendar.current
    }()
    
    var authorized: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    public func requestPermission() -> Observable<Bool>{
        let steps = Set([HKObjectType.quantityType(forIdentifier: .stepCount)])
        return Observable.create { observer in
            self.healthStore.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(success)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
//    public func getSteps(forTheLast days: Int) {
//        
//        let endDate = Date()
//        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate)
//        
//        guard let type = HKSampleType.quantityType(forIdentifier: .stepCount) else { return }
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .none)
//        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: <#T##Int#>, sortDescriptors: <#T##[NSSortDescriptor]?#>, resultsHandler: <#T##(HKSampleQuery, [HKSample]?, Error?) -> Void#>)
//    }
    
}
