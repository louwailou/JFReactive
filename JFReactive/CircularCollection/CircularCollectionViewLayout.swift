//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Sun on 16/2/23.
//  Copyright © 2016年 Rounak Jain. All rights reserved.
//

import Foundation
import UIKit

class CircularCollectionViewLayout :UICollectionViewLayout {
  let itemSize = CGSize(width: 133, height: 173)
  
  
  var radius:CGFloat = 500{
    didSet {
      invalidateLayout()
    }
  }
  var attributesList = [CircularCollectionViewLayoutAttributes]();
  
  var angleperItem:CGFloat{
    return atan(itemSize.width / radius)
  }
  
  
  var angleAtExtreme: CGFloat {
    return collectionView!.numberOfItemsInSection(0) > 0 ?
      -CGFloat(collectionView!.numberOfItemsInSection(0) - 1) * angleperItem : 0
  }
  var angle: CGFloat {
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize().width -
      CGRectGetWidth(collectionView!.bounds))
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width:CGFloat( collectionView!.numberOfItemsInSection(0)) * itemSize.width, height: CGRectGetHeight(collectionView!.bounds))
  }
 
  override func prepareLayout() {
   super.prepareLayout()
    let centerx = collectionView!.contentOffset.x + (CGRectGetWidth(collectionView!.bounds)/2.0)
    
    attributesList = (0..<collectionView!.numberOfItemsInSection(0)).map({ (i) -> CircularCollectionViewLayoutAttributes in
     let attributes = CircularCollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
      attributes.size = self.itemSize;
      let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      attributes.center = CGPoint(x: centerx, y: CGRectGetMidY(self.collectionView!.bounds))
      attributes.angle = self.angle + (self.angleperItem * CGFloat(i))
      return attributes ;
      
      
    })
  }
  func getTheta(){
    let theta = atan2(CGRectGetWidth(collectionView!.bounds) / 2.0,
      radius + (itemSize.height / 2.0) - (CGRectGetHeight(collectionView!.bounds) / 2.0))
    // 2
    var startIndex = 0
    var endIndex = collectionView!.numberOfItemsInSection(0) - 1
    // 3
    if (angle < -theta) {
      startIndex = Int(floor((-theta - angle) / self.angleperItem))
    }
    // 4
    endIndex = min(endIndex, Int(ceil((theta - angle) / self.angleperItem)))
    // 5
    if (endIndex < startIndex) {
      endIndex = 0
      startIndex = 0
    }
  }
  override class func  layoutAttributesClass() ->AnyClass{
     return CircularCollectionViewLayoutAttributes.self
  }
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  
}