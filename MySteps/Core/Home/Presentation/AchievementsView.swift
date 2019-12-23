//
//  AchievementsView.swift
//  MySteps
//
//  Created by Fernando Frances  on 18/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class AchievementsView: UIView, NibLoadableView {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var items: [Achievement] {
//        get { return _items.value }
//        set { _items.accept(newValue) }
//    }
    
    var items: [Achievement]? {
        didSet {
            guard let items = items else { return }
            self.countLabel.text = String(items.count)
            var achievements: [Achievement] = []
            var index = 0
            let interval = 0.1
            _ = Observable<Int>.timer(interval, period: interval, scheduler: MainScheduler.instance).take(items.count - 1).subscribe { _ in
                achievements.append(items[index])
                self._items.accept(achievements)
                index += 1
            }.disposed(by: disposeBag)
        }
    }
    
    let disposeBag = DisposeBag()
    private let _items = BehaviorRelay<[Achievement]>(value: [])
    
    typealias AchievementsSectionModel = AnimatableSectionModel<String, Achievement>
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AchievementsSectionModel>!
    
    private var configureCell: RxCollectionViewSectionedAnimatedDataSource<AchievementsSectionModel>.ConfigureCell {
        return { _, collectionView, indexPath, achievement in
            let cell: AchievementCell = collectionView.dequeueReusableCell(AchievementCell.self, for: indexPath)
            cell.configure(with: achievement)
            return cell
        }
    }
    
    func configure(items: [Achievement]) {
        self.items = items
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(AchievementCell.self)
        dataSource = RxCollectionViewSectionedAnimatedDataSource<AchievementsSectionModel>(configureCell: configureCell)

        _items.asObservable()
            .map {[AchievementsSectionModel(model: "", items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    
                
    }
    
}
