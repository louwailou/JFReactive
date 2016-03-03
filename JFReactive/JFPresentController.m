//
//  JFPresentController.m
//  JFReactive
//
//  Created by Sun on 16/3/3.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "JFPresentController.h"

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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
