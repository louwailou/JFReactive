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
@implementation JFTableController
- (void)viewDidLoad{
    [super viewDidLoad];
   
    
    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
    // 基本动画和layer的使用
    JFBaseModel *model = [[JFBaseModel alloc]init];
    model.name = @"JFGraphicContrller";
    model.vcDescription = @"动画显示图形绘制过程";
    [self.listArray addObject:model];
    
    
    //所有使用stroryBoard 都需要设置identifier
     model = [[JFBaseModel alloc]init];
    model.name = @"CollectionViewController";
    model.vcDescription = @"CollectionCircle";
    [self.listArray addObject:model];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFBaseModel * model = [self.listArray objectAtIndex:indexPath.row];
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController * vc =  [story instantiateViewControllerWithIdentifier:model.name];
    if (!vc) {
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
