//
//  JFFindFlowLayout.m
//  JiuFuWallet
//
//  Created by Sun on 16/6/12.
//  Copyright © 2016年 jayden. All rights reserved.
//

#import "JFFindFlowLayout.h"

@implementation JFFindFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
}

- (CGSize)collectionViewContentSize{
    
    return CGSizeZero;
    
}
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect // return an array layout attributes instances for all the views in the given rect
{
    NSArray *oldItems = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *allItems = [[NSMutableArray alloc]initWithArray:oldItems copyItems:YES];
    __block UICollectionViewLayoutAttributes *headerAttributes = nil;
    
    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;
        
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            attributes.size = CGSizeMake(200, 40);
        }
        else {
           
             attributes.size = CGSizeMake(50, 50);
        }
    }];
    
    return allItems;
    
}
// 返回cell 的
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 1) {
        attributes.size = CGSizeMake(320, 50);
    }else{
         attributes.size = CGSizeMake(50, 50);
    }
   
    return attributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    if([elementKind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attributes.size = CGSizeMake(self.collectionView.frame.size.width, 40);
        return attributes;
    }
    
    return  nil;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
