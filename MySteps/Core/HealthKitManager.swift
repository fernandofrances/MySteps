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
    
    
    public func getSteps(for dateIntervals: [DateInterval]) -> Observable<StepsData> {
        return Observable.create { observer in
            
            if let type = HKSampleType.quantityType(forIdentifier: .stepCount) {
                var interval = DateComponents()
                interval.day = 1
                
                dateIntervals.forEach { dateInterval in
                    let start = dateInterval.startDate
                    let end = dateInterval.endDate
                    let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
                    let query = HKStatisticsCollectionQuery(quantityType: type,
                                                            quantitySamplePredicate: predicate,
                                                            options: [.cumulativeSum],
                                                            anchorDate: start,
                                                            intervalComponents: interval)
                    query.initialResultsHandler = { query, results, error in
                        if let error = error {
                            observer.onError(error)
                        }
                        
                        if let results = results {
                            results.enumerateStatistics(from: start, to: end) { statistics, stop in
                                if let quantity = statistics.sumQuantity() {
                                    let steps = quantity.doubleValue(for: .count())
                                    observer.onNext(StepsData(day: start, stepCount: steps))
                                }
                            }
                        }
                        observer.onCompleted()
                    }
                    
                    self.healthStore.execute(query)
                }
            }
            return Disposables.create()
        }
    }
    
//    func getSteps(startDate: Date, endDate: Date) -> Observable<(Date,Double)> {
//
//        guard let type = HKSampleType.quantityType(forIdentifier: .stepCount) else { return Observable.error(RxError.unknown) }
//
//
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//        var interval = DateComponents()
//        interval.day = 1
//
//        let query = HKStatisticsCollectionQuery(quantityType: type,
//                                                quantitySamplePredicate: predicate,
//                                                options: [.cumulativeSum],
//                                                anchorDate: startDate,
//                                                intervalComponents: interval)
//
//        return Observable.create { [weak self] observer in
//            query.initialResultsHandler = { query, results, error in
//                if let error = error {
//                    observer.onError(error)
//                }
//
//                if let results = results {
//                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
//                        if let quantity = statistics.sumQuantity() {
//                            let steps = quantity.doubleValue(for: .count())
//                            observer.onNext((startDate,steps))
//                        }
//                    }
//                }
//                observer.onCompleted()
//            }
//            self?.healthStore.execute(query)
//
//            return Disposables.create()
//        }
//    }
    
}
