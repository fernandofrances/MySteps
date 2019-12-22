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
            items.enumerated().forEach { arg in
                let (index, item) = arg
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds((index + 1)*100)) {
                    achievements.append(item)
                    self._items.accept(achievements)
                }
            }
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
    
    private var canMoveItemAtIndexPath: RxCollectionViewSectionedAnimatedDataSource<AchievementsSectionModel>.CanMoveItemAtIndexPath {
        return { _, _ in
            return false
        }
    }
    
    
    func configure(items: [Achievement]) {
        self.items = items
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(AchievementCell.self)

        dataSource = RxCollectionViewSectionedAnimatedDataSource<AchievementsSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .bottom, reloadAnimation: .bottom, deleteAnimation: .fade), configureCell: configureCell, canMoveItemAtIndexPath: canMoveItemAtIndexPath)


        _items.asObservable()
            .map {[AchievementsSectionModel(model: "", items: $0)]}
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
                
    }
    
}
