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
    
}
