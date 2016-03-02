//
//  LayoutAttributes.swift
//  CircularCollectionView
//
//  Created by Sun on 16/3/1.
//  Copyright © 2016年 Rounak Jain. All rights reserved.
//

import Foundation
import UIKit
class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  // 1
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    // 2
    didSet {
      zIndex = Int(angle * 1000000.0)
      transform = CGAffineTransformMakeRotation(angle)
    }
  }
  
  override func copyWithZone(zone: NSZone) -> AnyObject {
    
    let copiedAttributes: CircularCollectionViewLayoutAttributes =
    super.copyWithZone(zone) as! CircularCollectionViewLayoutAttributes
    copiedAttributes.anchorPoint = self.anchorPoint
    copiedAttributes.angle = self.angle
    return copiedAttributes
  }
}
