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
    func updateStepCount(_ steps: Double)
}

class HomePresenter {
    
    
    weak var view: HomeView?
    private let repository: HomeRepository
    private let user: User
    
    private let disposeBag = DisposeBag()
    private let daysToShow: Int = 30
    
    
    init(repository: HomeRepository, user: User) {
        self.repository = repository
        self.user = user
    }
    
    
    func didLoad() {
        repository.createUserInPersistanceStore(user)
        rxBind()
        configureHeader()
        loadData()
    }
    
    func rxBind() {
        repository.rx.stepCount.subscribe(onNext: { [weak self] count in
            guard let `self` = self else {  return }
            self.view?.updateStepCount(count)
        }).disposed(by: disposeBag)
    }
    
    private func loadData() {
        repository.loadStepData()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (pointEntries, totalStepCount) in
                guard let `self` = self else { return }
                self.repository.updateUserStepsInPersistanceStore(totalStepCount)
                self.configureChart(pointEntries)
                self.configureAchievements(totalStepCount)
            }, onError: { error in
                    // Handle error
            }).disposed(by: disposeBag)
    }
    
    private func configureHeader() {
        view?.title = user.name
        let dates = repository.dateIntervals()
        guard let start = dates.first?.startDate, let end = dates.last?.startDate else { return }
        let interval = DateInterval(startDate: start, endDate: end)
        view?.updateHeader(with: user, dateInterval: interval)
    }
    
    private func configureChart(_ pointEntries: [PointEntry]) {
        self.view?.updateChart(with: pointEntries)
    }
    
    private func configureAchievements(_ stepCount: Double) {
        let gap = 5000
        var i = 10000
        var achievements: [Achievement?] = []
        while Int(stepCount) >= i {
            achievements.append(Achievement(rawValue: Double(i)))
            i += gap
        }
        view?.updateAchievements(with: achievements.compactMap( { $0 }))
    }
  
    
}

