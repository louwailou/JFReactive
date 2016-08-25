//
//  JFTableController.m
//  JFReactive
//
//  Created by Sun on 16/3/2.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "JFTableController.h"
#import "JFBaseModel.h"
#import "JFBaseCell.h"
#import "JFReactive-swift.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@implementation JFTableController
- (void)viewDidLoad{
    [super viewDidLoad];
    // 优化数组。。。
    NSArray * names = @[@"RACViewController",@"JFGraphicContrller",@"CollectionViewController",@"SCCornerViewController",@"SCPrimerViewController",@"JFTransitionController",@"ScaleTOneController",@"JFFindViewController",@"AutoLayout_ScrollviewVC"];
    NSArray * descriptions = @[@"RAC_Practice",@"动画StrokeEnd&StrokeStart",@"CollectionCircle Swift实现",@"CollectionCorner",@"collection缩放显示",@"自定义tansitionAnimation",@"Path animation   Trasition",@"collection",@"测试uiscrollview 的自动布局"];
    NSArray* fromStrotyBoard = @[@1,@1,@1,@1,@1,@0,@1,@1,@0];
    
    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0 ; i<[names count];i++){
        JFBaseModel *model = [[JFBaseModel alloc]init];
        model.name = names[i];
        model.fromStory = [fromStrotyBoard[i] boolValue];
        model.vcDescription = descriptions[i];
        [self.listArray addObject:model];
    }
    [self.tableView reloadData];
    
    NSArray * arr = [NSArray arrayWithObjects:@"22.44",@"42.33", nil];
  
    NSArray *resultArray = [arr valueForKeyPath:@"doubleValue.intValue"];
    NSLog(@"%@", resultArray);
   // NSLog(@"count = %@", [valueForKey:@"@count"]);
    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
// 注意规范
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFBaseModel * model = [self.listArray objectAtIndex:indexPath.row];
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = nil;
    if (model.fromStory) {
       vc =  [story instantiateViewControllerWithIdentifier:model.name];
    }else{
        vc = [[NSClassFromString(model.name) alloc] init];
    }
  
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JFBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell"];
    if (!cell) {
        // BaseCell 在stroyBoard 中的identifier 需要设置
        cell = [[JFBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseCell"];
    }
    JFBaseModel * model = [self.listArray objectAtIndex:indexPath.row];
    [cell.name setText:model.vcDescription];
    return cell;
}
@end
