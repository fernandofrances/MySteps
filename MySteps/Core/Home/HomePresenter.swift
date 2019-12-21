//
//  HomePresenter.swift
//  MySteps
//
//  Created by Fernando Frances  on 20/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation
import RxSwift

protocol HomeView: class {
    
    var title: String? { get set }
    
    func updateHeader(with user: User, dateInterval: DateInterval)
    func updateChart(with points: [PointEntry])
    func updateAchievements(with achievements: [Achievement])
}

class HomePresenter {
    
    
    weak var view: HomeView?
    
    private lazy var calendar: Calendar = { return Calendar.current }()
    private let healthManager: HealthKitManager
    private let user: User
    private let disposeBag = DisposeBag()
    private let daysToShow: Int = 30
    
    
    init(healthManager: HealthKitManager,
         repository: HomeRepository,
         user: User) {
        self.healthManager = healthManager
        self.user = user
    }
    
    
    func didLoad() {
        configureHeader()
        configureDummyChart()
        //configureChart()
        configureAchievements()
    }
    
    private func configureChart() {
        loadStepData()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] pointEntries in
                guard let `self` = self else { return }
                self.view?.updateChart(with: pointEntries)
            }, onError: { error in
                // Handle error
            }).disposed(by: disposeBag)
    }
    
    private func configureDummyChart() {
        loadDummyStepData()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] pointEntries in
            guard let `self` = self else { return }
            self.view?.updateChart(with: pointEntries)
        }, onError: { error in
            // Handle error
        }).disposed(by: disposeBag)
    }
    
    private func configureHeader() {
        view?.title = user.name
        let dates = dateIntervals()
        guard let start = dates.first?.startDate, let end = dates.last?.startDate else { return }
        let interval = DateInterval(startDate: start, endDate: end)
        view?.updateHeader(with: user, dateInterval: interval)
    }
    
    private func configureAchievements() {
        view?.updateAchievements(with: [])
    }
    
    private func dateIntervals() -> [DateInterval] {
        var dates: [DateInterval] = []
        let today = Date()
        for n in 0...daysToShow {
            let day = self.calendar.date(byAdding: .day, value: -n, to: today)
            if let startOfDay = day?.startOfDay, let endOfDay = day?.endOfDay {
                dates.append(DateInterval(startDate: startOfDay, endDate: endOfDay))
            }
        }
        return dates.reversed()
    }
}

private extension HomePresenter {
    
    func loadStepData() -> Observable<[PointEntry]> {
        
        if !healthManager.authorized { return Observable.error(RxError.unknown) }
        
        return healthManager.requestPermission()
            .flatMap { [weak self] granted -> Observable<StepsData> in
                guard let `self` = self, granted else { return Observable.error(RxError.unknown) }
                return self.healthManager.getSteps(for: self.dateIntervals())
            }
            .map { stepData in
               PointEntry(value: Int(stepData.stepCount),
                          label: String(self.calendar.component(.day,from: stepData.day)))
            }
            .reduce([]) { array, element in array + [element] }
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
