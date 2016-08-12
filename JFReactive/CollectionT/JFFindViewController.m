//
//  JFFindViewController.m
//  JiuFuWallet
//
//  Created by Sun on 16/6/12.
//  Copyright © 2016年 jayden. All rights reserved.
//

#import "JFFindViewController.h"
#import "JFFindFlowLayout.h"
#import "JFFindCell.h"
#import "JFFindHeaderCell.h"
#import "JFFindHeaderView.h"
#import "JFFooterView.h"
#import <Masonry/Masonry.h>
 static NSString *cellIdentifier = @"JFFindCellIdentifier"
;
static NSString *headerIdentifier = @"JFFindHeaderIdentifier";
static NSString *footerIdentifier = @"JFFindFooterIdentifier";
static NSString *headerCellIdentifier = @"JFFindHeaderCellIdentifier";
const static CGFloat lineSpacing = 1;
const static CGFloat itemSpacing = 1;
@interface JFFindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)  UICollectionView *myCollectionView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign,nonatomic) CGFloat itemWidth;
@property (assign,nonatomic) CGFloat itemHeight;
@end

@implementation JFFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // JFFindFlowLayout * layout = [[JFFindFlowLayout alloc] init];
    // 设置布局
   UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
       self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myCollectionView];
    
    [self.myCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
   
    
    self.itemWidth = (self.view.frame.size.width - 3*itemSpacing)/4.0;
    self.itemHeight = 60;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"JFFindCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
     [self.myCollectionView registerNib:[UINib nibWithNibName:@"JFFindHeaderCell" bundle:nil] forCellWithReuseIdentifier:headerCellIdentifier];
    
    
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"JFFindHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
      [self.myCollectionView registerNib:[UINib nibWithNibName:@"JFFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    
    for ( int i = 0; i < 16; i++) {
        [self.dataList addObject:[NSNumber numberWithInt:i]];
    }
    //self.myCollectionView
    // Do any additional setup after loading the view from its nib.
}
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _dataList;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma  mark DataSource 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 15;
        case 2:
            return 1;
        case 3:
            return 10;
        default:
            break;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2) {
        JFFindHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCellIdentifier forIndexPath:indexPath];
        return cell;
    }else{
        JFFindCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
 
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
         JFFindHeaderView* header=  [self.myCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        return header;
    }else{
        
        JFFooterView* footer=  [self.myCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        return footer;

    }
}

#pragma mark delegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return CGSizeMake(collectionView.frame.size.width, 80);
    }
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return CGSizeMake(0, 0);
        case 1:
            return CGSizeMake(0, 40);
            case 2:
            return CGSizeMake(0, 10);
            case 3:
            return CGSizeMake(0, 40);
        default:
            break;
    }
   
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return lineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return itemSpacing;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
