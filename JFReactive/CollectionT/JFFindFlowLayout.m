//
//  JFFindFlowLayout.m
//  JiuFuWallet
//
//  Created by Sun on 16/6/12.
//  Copyright © 2016年 jayden. All rights reserved.
//
#pragma  mark 使用autolayout 不能设置frame了
#import "JFFindFlowLayout.h"
const static NSInteger verticalNumber = 4 ;
const static CGFloat headerCellHeight = 80;
const static CGFloat headerViewHeight = 40;

@interface JFFindFlowLayout ()
@property (assign, nonatomic)CGFloat itemHeight;
@property (assign,nonatomic)CGFloat itemWidth;
@property (assign,nonatomic)CGFloat lineSpacing;
@property (assign,nonatomic)CGFloat baseX ;
@property (assign,nonatomic)CGFloat baseY ;
@property (strong,nonatomic)UICollectionViewLayoutAttributes *lastAttributes;
@end
@implementation JFFindFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    self.itemHeight = 60;
    self.lineSpacing = 1;
   
    CGRect bounds = self.collectionView.bounds;
    //(CGRect) bounds = (origin = (x = 0, y = -64), size = (width = 375, height = 667))
    self.itemWidth = (bounds.size.width - self.lineSpacing*(verticalNumber -1))/verticalNumber;
    
}

- (CGSize)collectionViewContentSize{
    CGFloat height = 0;
   NSInteger section =  [self.collectionView numberOfSections];
    for (int i = 0; i < section; i ++) {
        if (i == 0 || i == 2) {
            height += headerCellHeight;
        }else{
            NSInteger rows = [self.collectionView numberOfItemsInSection:i];
            height += (rows/verticalNumber + 1)*self.itemHeight ;
        }
       
    }
    height += section*headerViewHeight;
    
    return CGSizeMake(self.collectionView.frame.size.width, height);
    
}
/*
 Subclasses must override this method and use it to return layout information for all items whose view intersects the specified rectangle. Your implementation should return attributes for all visual elements, including cells, supplementary views, and decoration views.
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect // return an array layout attributes instances for all the views in the given rect
{

    NSArray *oldItems = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *allItems = [[NSMutableArray alloc]initWithArray:oldItems copyItems:YES];
   
    
//    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        UICollectionViewLayoutAttributes *attributes = obj;
//        
//        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
//            if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//               // attributes.size = CGSizeMake(self.collectionView.bounds.size.width, 40);
//            }
//            
//            //attributes.size = CGSizeMake(200, headerViewHeight);
//        }else if(attributes.representedElementCategory == UICollectionElementCategoryCell){
//            
//            // attributes.size = CGSizeMake(self.itemWidth, self.itemHeight);
//           
//        }
//        
//    }];
    
    //return allItems;
    
  
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [attributesArray addObject:attributes];
       
        
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
    }
}
    
    return attributesArray;
   
}


// 返回cell 的
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // NSLog(@"item indexPath =%d %d",indexPath.section,indexPath.row);
    [self resetAttributes:attributes indexPath:attributes.indexPath];
    self.lastAttributes = attributes;
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"supplementView indexPath =%d %d",indexPath.section,indexPath.row);
    if([elementKind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
       
        [self resetHeaderAttribute:attributes indexPath:indexPath];
        self.lastAttributes = attributes;
        return attributes;
    }
    
    return  nil;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (void)resetAttributes:(UICollectionViewLayoutAttributes*)attributes indexPath:(NSIndexPath*)indexPath{
    CGRect lastFrame = CGRectZero;
    self.baseX = 0;
    self.baseY = 0;
    if (self.lastAttributes) {
        lastFrame = self.lastAttributes.frame;
        if (self.lastAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            
            NSInteger rows = [self.collectionView numberOfItemsInSection:indexPath.section];
            if (indexPath.row != 0 && rows % verticalNumber == 0) {
                self.baseY = CGRectGetMaxY(lastFrame);
            }else if(indexPath.row == 0){
                self.baseY = CGRectGetMaxY(lastFrame);
            }else{
                 self.baseY = CGRectGetMinY(lastFrame);
            }
            // 如果是cell 就取最大值
            self.baseX = CGRectGetMaxX(lastFrame);
            
        }else{
            self.baseY = CGRectGetMaxY(lastFrame);
            // 如果是supply 就去最小
        }
        
    }
    switch (indexPath.section) {
        case 0:{
            
            #pragma  mark 使用autolayout 不能设置frame了》》》》》》 如果你正在使用自动布局，你可能会感到惊讶，我们正在直接修改布局参数的 frame 属性，而不是和约束共事，但这正是 UICollectionViewLayout 的工作。尽管你可能使用自动布局来定义collection view 的 frame 和它内部每个 cell 的布局，但 cells 的 frames 还是需要通过老式的方法计算出来
            
            
            attributes.frame = CGRectMake(self.baseX, self.baseY,self.collectionView.bounds.size.width, headerCellHeight) ;
           // self.baseY += headerCellHeight;
            
            break;
        }
        case 1: case 3:{
            // header
//            NSInteger row = indexPath.row;
//            if (row == 0) {
//                 self.baseY += headerViewHeight;
//            }else if(row % verticalNumber == 0){
//                  self.baseY += (self.itemHeight+ self.lineSpacing);
//            }
//            
//            self.baseX = (indexPath.row % verticalNumber)*(self.itemWidth+self.lineSpacing);
//            
            attributes.frame = CGRectMake(self.baseX, self.baseY,self.itemWidth, self.itemHeight) ;
            
            break;
        }
        case 2:{
//            self.baseY += (headerViewHeight+self.itemHeight); // header
//            self.baseX = 0 ;
            attributes.frame = CGRectMake(self.baseX, self.baseY,self.collectionView.bounds.size.width, headerCellHeight) ;
            //self.baseY += headerCellHeight;
            NSLog(@"basey= %f",self.baseY);
            break;
        }
       
        default:
            break;
    }
    
}
- (void)resetHeaderAttribute:(UICollectionViewLayoutAttributes*)attributes indexPath:(NSIndexPath*)indexPath{
    // section 0 没有
    
    NSInteger rows = [self.collectionView numberOfItemsInSection:indexPath.section-1];
    UICollectionViewLayoutAttributes *cellAtt = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:rows -1 inSection:indexPath.section-1]];
    CGRect frame = cellAtt.frame;
  CGFloat  y = CGRectGetMaxY(frame)+self.lineSpacing;
    switch (indexPath.section) {
            
        case 1: case 3:{
            attributes.frame =CGRectMake(0,y , self.collectionView.bounds.size.width, headerViewHeight);
            break;
        }
        case 2:{
            
           attributes.frame =CGRectMake(0,y, self.collectionView.bounds.size.width, 40);
            break;
        }
        default:
            break;
    }
}
@end
