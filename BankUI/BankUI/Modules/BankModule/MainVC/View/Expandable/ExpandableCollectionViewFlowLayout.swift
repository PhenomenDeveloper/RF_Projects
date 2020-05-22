//
//  ExpandableCollectionViewFlowLayout.swift
//  BankUI
//
//  Created by OMELCHUK Daniil on 25.02.2020.
//  Copyright © 2020 Korneev Viktor. All rights reserved.
//

import UIKit

class ExpandableCollectionViewFlowLayout: UICollectionViewFlowLayout {
    ///Высота ячеек
    private var cellHeight: CGFloat = 60

    ///Ширина ячеек
    private var cellWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    ///Раскрыто ли представление коллекции
    var isExpandable = false
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let items = super.layoutAttributesForElements(in: rect) else {return nil}
        
        if !isExpandable {
            var padding: CGFloat = 10
            var zindex = 5
            var attrs: [UICollectionViewLayoutAttributes] = []
            
            for i in 0..<items.count {
                attrs.append(items[i])
                attrs[i].frame = CGRect(x: padding, y: padding, width: cellWidth - padding * 2, height: cellHeight)
                attrs[i].zIndex = zindex
                zindex -= 1
                padding += 10
                if i >= 3 {
                    attrs[i].alpha = 0
                }
            }
            
            return attrs
        } else {
            return items.map({ attrs in
                attrs.transform3D = CATransform3DIdentity
                
                return attrs
            })
        }
    }
}

