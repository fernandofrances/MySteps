//
//  MainViewController.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
   
    private let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.didLoad()
    }
}


extension HomeViewController: HomeView {
    
    func addHeader(with user: User, timePeriod: TimePeriod) {
        let header = HeaderView.instantiate()
        header.configure(with: user, timePeriod: timePeriod)
        stackView.addArrangedSubview(header)
     }
    
    func updateStepDataViews(with points: [PointEntry], achievements: [Achievement]) {
        stackView.arrangedSubviews.forEach {
            if !$0.isKind(of: HeaderView.self) { $0.removeFromSuperview() }
        }
        
        let stepsChart = StepsView.instantiate()
        stepsChart.configure(with: points)
        stackView.addArrangedSubview(stepsChart)
        
        if achievements.count == 0 {
            let noAchievementsView = NoAchievementsView.instantiate()
            stackView.addArrangedSubview(noAchievementsView)
        } else {
            let achievementsView = AchievementsView.instantiate()
            achievementsView.items = achievements
            stackView.addArrangedSubview(achievementsView)
        }
        
        
    }
    
    func updateStepCountView(_ steps: Double) {
        guard let header = stackView.arrangedSubviews.first(where: { $0.isKind(of: HeaderView.self )}) as? HeaderView else { return }
        header.stepCountLabel.text = steps.stringWithThousendSeparator
    }
    
    func updateTimePeriodView(with timePeriod: TimePeriod) {
        guard let header = stackView.arrangedSubviews.first(where: { $0.isKind(of: HeaderView.self )}) as? HeaderView else { return }
        header.updateTimePeriodLabel(timePeriod)
    }
 
    
}
