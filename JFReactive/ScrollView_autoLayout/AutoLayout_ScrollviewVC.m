//
//  AutoLayout_ScrollviewVC.m
//  JFReactive
//
//  Created by Sun on 16/8/12.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "AutoLayout_ScrollviewVC.h"
#import <Masonry/Masonry.h>
#import "ScrollVC1.h"
#import "Example2Controller.h"
#import "Example3Controller.h"
#import "Example4Controller.h"
@implementation AutoLayout_ScrollviewVC
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn1];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    [btn1 addTarget:self action:@selector(skipToSV1) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn2];
     [btn2 setTitle:@"2" forState:UIControlStateNormal];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    [btn2 setBackgroundColor:[UIColor redColor]];
    [btn2 addTarget:self action:@selector(skipToSV2) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn3];
     [btn3 setTitle:@"3" forState:UIControlStateNormal];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    [btn3 addTarget:self action:@selector(skipToSV3) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundColor:[UIColor redColor]];
    
    
    UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn4];
     [btn4 setTitle:@"4" forState:UIControlStateNormal];
    
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn3.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    [btn4 addTarget:self action:@selector(skipToSV4) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setBackgroundColor:[UIColor redColor]];
    
}


- (void)skipToSV1{
    ScrollVC1 * vc = [[ScrollVC1 alloc ] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)skipToSV2{
    Example2Controller * vc = [[Example2Controller alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
}

- (void)skipToSV3{
    Example3Controller * vc = [[Example3Controller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)skipToSV4{
    Example4Controller * vc = [[Example4Controller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
