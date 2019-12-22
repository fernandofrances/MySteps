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
    
//    override func targetContentOffset(
//        forProposedContentOffset proposedContentOffset: CGPoint,
//        withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        guard let collectionView = collectionView else {
//            return proposedContentOffset
//        }
//
//        // When scrolling we want the collection view to snap to item boundaries
//
//        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView.bounds.size)
//
//        guard let attributes = layoutAttributesForElements(in: targetRect) else {
//            return proposedContentOffset
//        }
//
//        // Iterate through all the visible items to find the closest to the proposed content offset,
//        // then adjust the proposed offset to be the origin of that item
//
//        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
//
//        for itemAttributes in attributes {
//            if itemAttributes.representedElementCategory != .cell {
//                continue
//            }
//
//            let x = itemAttributes.frame.origin.x
//
//            if abs(x - proposedContentOffset.x) < abs(offsetAdjustment) {
//                offsetAdjustment = x - proposedContentOffset.x
//            }
//        }
//
//        return CGPoint(x: proposedContentOffset.x + offsetAdjustment - sectionInset.left, y: proposedContentOffset.y)
//    }
}
