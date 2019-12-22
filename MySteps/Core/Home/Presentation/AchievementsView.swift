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

final class AchievementsView: UIView, NibLoadableView {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [Achievement] {
        get { return _items.value }
        set { _items.accept(newValue) }
    }
    
    let disposeBag = DisposeBag()
    private let _items = BehaviorRelay<[Achievement]>(value: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(AchievementCell.self)
        
        _items.asObservable()
            .do(onNext: { [weak self] items in
                guard let `self` = self else { return }
                self.countLabel.text = String(items.count)
            })
            .bind(to: collectionView.rx.items) { collectionView, index, item in
                let cell = collectionView.dequeueReusableCell(AchievementCell.self, for: index)
                cell.configure(with: item)
                return cell
        }.disposed(by: disposeBag)
        
    }
    
}
