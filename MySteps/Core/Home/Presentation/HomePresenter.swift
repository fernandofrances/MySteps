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
    
    func addHeader(with user: User, timePeriod: TimePeriod)
    func updateStepCountView(_ steps: Double)
    func updateStepDataViews(with points: [PointEntry], achievements: [Achievement])
    func updateTimePeriodView(with timePeriod: TimePeriod)
}

class HomePresenter {
    
    
    weak var view: HomeView?
    private let repository: HomeRepository
    private let user: User
    
    let disposeBag = DisposeBag()
    private var timePeriod: TimePeriod = .currentMonth
    
    
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
    
    func switchTimePeriodMode() {
        switch timePeriod {
        case .lastThirtyDays:
            timePeriod = .currentMonth
        case .currentMonth:
            timePeriod = .lastThirtyDays
        }
        self.view?.updateTimePeriodView(with: timePeriod)
        loadData()
    }
    
    private func rxBind() {
        repository.rx.stepCount.subscribe(onNext: { [weak self] count in
            guard let `self` = self else {  return }
            self.view?.updateStepCountView(count)
        }).disposed(by: disposeBag)
    }
    
    private func loadData() {
        repository.loadStepData(timePeriod: timePeriod)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (pointEntries, totalStepCount) in
                guard let `self` = self else { return }
                self.repository.updateUserStepsInPersistanceStore(totalStepCount)
                self.view?.updateStepDataViews(with: pointEntries, achievements: self.achievements(totalStepCount))
            }, onError: { error in
                    // Handle error
            }).disposed(by: disposeBag)
    }
    
    private func configureHeader() {
        view?.title = user.name
        view?.addHeader(with: user, timePeriod: timePeriod)
    }
    
    private func achievements(_ stepCount: Double) -> [Achievement] {
        let gap = 5000
        var i = 10000
        var achievements: [Achievement?] = []
        while Int(stepCount) >= i {
            achievements.append(Achievement(rawValue: Double(i)))
            i += gap
        }
        return achievements.compactMap { $0 }
    }
    
}

