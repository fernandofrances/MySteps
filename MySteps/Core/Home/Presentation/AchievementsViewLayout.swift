//
//  AchievementsViewLayout.swift
//  MySteps
//
//  Created by Fernando Frances  on 22/12/2019.
//  Copyright © 2019 Fernando Frances . All rights reserved.
//

import Foundation
import UIKit

final class AchievementsViewLayout: UICollectionViewFlowLayout {
    private enum Constants {
        static let itemSize = CGSize(width: 148, height: 212)
        static let minimumLineSpacing: CGFloat = 0
        static let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        
        scrollDirection = .horizontal
        itemSize = Constants.itemSize
        minimumLineSpacing = Constants.minimumLineSpacing
        sectionInset = Constants.sectionInset
    
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attrs?.alpha = 0.0
        let x = CGFloat(itemIndexPath.row) * itemSize.width
        attrs?.frame = CGRect(x: x, y: 35, width: itemSize.width, height: itemSize.height)
        
        return attrs
    }
    
}
