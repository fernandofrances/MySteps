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
    
    public func getSteps(for dateIntervals: [DateInterval]) -> Observable<[StepsData]> {
        return Observable.zip(dateIntervals.map { getSteps(dateInterval: $0)})
    }
    
    func getSteps(dateInterval: DateInterval) -> Observable<StepsData> {

        guard let type = HKSampleType.quantityType(forIdentifier: .stepCount) else { return Observable.error(RxError.unknown) }


        let predicate = HKQuery.predicateForSamples(withStart: dateInterval.startDate, end: dateInterval.endDate, options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: type,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: dateInterval.startDate,
                                                intervalComponents: interval)

        return Observable.create { [weak self] observer in
            query.initialResultsHandler = { query, results, error in
                if let error = error {
                    observer.onError(error)
                }

                if let results = results {
                    results.enumerateStatistics(from: dateInterval.startDate, to: dateInterval.endDate) { statistics, stop in
                        if let quantity = statistics.sumQuantity() {
                            let steps = quantity.doubleValue(for: .count())
                            observer.onNext(StepsData(day: dateInterval.startDate, stepCount: steps))
                        }
                    }
                }
                observer.onCompleted()
            }
            self?.healthStore.execute(query)

            return Disposables.create()
        }
    }
    
}
