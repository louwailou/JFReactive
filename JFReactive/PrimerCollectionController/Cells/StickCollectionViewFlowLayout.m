//
//  StickCollectionViewFlowLayout.m
//  StickCollectionView
//
//  Created by Bogdan Matveev on 21/09/15.
//  Copyright (c) 2015 Bogdan Matveev. All rights reserved.
//

#import "StickCollectionViewFlowLayout.h"

@implementation StickCollectionViewFlowLayout

// 这里是使用了FlowLayout 所以直接super
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *oldItems = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *allItems = [[NSMutableArray alloc]initWithArray:oldItems copyItems:YES];
    
    __block UICollectionViewLayoutAttributes *headerAttributes = nil;
    
    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;
        
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            headerAttributes = attributes;// header = nil
        }
        else {
            [self updateCellAttributes:attributes withSectionHeader:headerAttributes];
            
        }
    }];
    
    return allItems;
}

- (void)updateCellAttributes:(UICollectionViewLayoutAttributes *)attributes withSectionHeader:(UICollectionViewLayoutAttributes *)headerAttributes {
    
    CGFloat minY = CGRectGetMinY(self.collectionView.bounds) + self.collectionView.contentInset.top;
    CGFloat maxY = attributes.frame.origin.y - CGRectGetHeight(headerAttributes.bounds);
    CGFloat finalY = MAX(minY, maxY);
    //NSLog(@"index = %ld   attributes.origin.y =%f boudsoriginY = %f  ",attributes.indexPath.row,maxY,CGRectGetMinY(self.collectionView.bounds));
   // NSLog(@"bounds = %@",NSStringFromCGRect(self.collectionView.bounds));
   //  NSLog(@"frames = %@",NSStringFromCGRect(self.collectionView.frame));
    
    // 注意 CGRectGetMinY(self.collectionView.bounds) 和 attributes.frame.origin.y 的值
    // collectionView的originY 是动态变化的
    // frame 是不变的 frames = {{0, 69.5}, {375, 597.5}}
    CGPoint origin = attributes.frame.origin;
    
    CGFloat deltaY = (finalY - origin.y) / CGRectGetHeight(attributes.frame);
    
    
    
    // 其实还可以修改为
    //CGFloat deltaY = ABS((CGRectGetMinY(self.collectionView.bounds) - origin.y)) / CGRectGetHeight(attributes.frame);
    

    if (self.firstItemTransform) {
        attributes.transform = CGAffineTransformMakeScale((1- deltaY * self.firstItemTransform), (1 - deltaY * self.firstItemTransform));
    }

    origin.y = finalY;
    attributes.frame = (CGRect){origin, attributes.frame.size};
    attributes.zIndex = attributes.indexPath.row;
    // 这里的要点就是理解collectionView 的origin.y 和attribute.y 的变化
    // zIndex

}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
