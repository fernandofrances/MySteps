//
//  HomeRepository.swift
//  MySteps
//
//  Created by Fernando Frances  on 21/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation
import RxSwift

protocol HomeRepositoryProtocol {
    
    // Persistance
    func createUserInPersistanceStore(_ user: User)
    func updateUserStepsInPersistanceStore(_ steps: Double)
    func getUserStepsFromPersistanceStore() -> Double
    
    // Health Kit
    
    func loadStepData() -> Observable<[PointEntry]>
    func loadDummyStepData() -> Observable<[PointEntry]>
    
    func dateIntervals() -> [DateInterval]

}

final class HomeRepository: HomeRepositoryProtocol {
    
    let dataManager: CoreDataManager
    let healthManager: HealthKitManager
    
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
     }
     
     func getUserStepsFromPersistanceStore() -> Double {
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
    
    func loadDummyStepData() -> Observable<[PointEntry]> {
        let pointEntries: [PointEntry] = [
            PointEntry(value: 0, label: "1"),
            PointEntry(value: 500, label: "2"),
            PointEntry(value: 2030, label: "3"),
            PointEntry(value: 5000, label: "4"),
            PointEntry(value: 5000, label: "5"),
            PointEntry(value: 7000, label: "6"),
            PointEntry(value: 0, label: "7"),
            PointEntry(value: 1002, label: "8"),
            PointEntry(value: 200, label: "9"),
            PointEntry(value: 300, label: "10"),
            PointEntry(value: 10000, label: "11"),
            PointEntry(value: 9000, label: "12"),
            PointEntry(value: 9003, label: "13"),
            PointEntry(value: 700, label: "14"),
            PointEntry(value: 200, label: "15"),
            PointEntry(value: 4002, label: "16"),
            PointEntry(value: 200, label: "17"),
            PointEntry(value: 500, label: "18"),
            PointEntry(value: 32223, label: "19"),
            PointEntry(value: 700, label: "20"),
            PointEntry(value: 200, label: "21"),
            PointEntry(value: 300, label: "22"),
            PointEntry(value: 200, label: "23"),
            PointEntry(value: 500, label: "24"),
            PointEntry(value: 600, label: "25"),
            PointEntry(value: 0, label: "26"),
            PointEntry(value: 200, label: "27"),
            PointEntry(value: 300, label: "28"),
            PointEntry(value: 0, label: "29"),
            PointEntry(value: 500, label: "30")]
        
        if !healthManager.authorized { return Observable.error(RxError.unknown) }
        return Observable.of(pointEntries)
    }
    
}
