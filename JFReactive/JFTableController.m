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
    // 优化数组
    NSArray * names = @[@"JFGraphicContrller",@"CollectionViewController",@"SCCornerViewController",@"SCPrimerViewController"];
    NSArray * descriptions = @[@"动画显示图形绘制过程",@"CollectionCircle swift 实现",@"SCCornerViewController",@"SCPrimerViewController"];
    
    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i =0 ; i<[names count];i++){
        JFBaseModel *model = [[JFBaseModel alloc]init];
        model.name = names[i];
        model.vcDescription = descriptions[i];
        [self.listArray addObject:model];
    }
    [self.tableView reloadData];
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
