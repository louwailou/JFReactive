//
//  JFPresentController.m
//  JFReactive
//
//  Created by Sun on 16/3/3.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "JFPresentController.h"
#import "JFTableController.h"

@interface JFPresentController (a)

@end

@interface JFPresentController ()

@end


@implementation JFPresentController
-(void)viewDidLoad{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(100, 100, 60, 40)];
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(show ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)show{
    // 设置nav 的viewControllers 如果是想动画效果，则必须是topView 在动画之前已经存在于栈中
    NSMutableArray * vcs = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
    [vcs removeAllObjects];
    JFTableController *vc = [[JFTableController alloc] init];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:NO];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        //    }];
}
@end
