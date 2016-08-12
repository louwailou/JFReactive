//
//  ScrollVC1.m
//  JFReactive
//
//  Created by Sun on 16/8/12.
//  Copyright © 2016年 Sun. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "ScrollVC1.h"

@interface ScrollVC1()
@property (nonatomic, strong) UIScrollView *scrollView;
@end


@implementation ScrollVC1
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    //scrollView
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
       make.size.equalTo(self.view).sizeOffset(CGSizeMake(-100,-400));
    }];
    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.clipsToBounds = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    
    //subviews
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor blueColor];
    containerView.alpha = 0.5;
    [scrollView addSubview:containerView];
    NSLog(@"frame = %@",NSStringFromCGRect(containerView.frame));
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);// 为何还要设置width height ???
        // svrollview 的contentsize 是依赖于containerView 的大小
        make.height.equalTo(scrollView).multipliedBy(1);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"frame2 = %@",NSStringFromCGRect(containerView.frame));
    });
    
    
    //frame
    UIView *frame = [UIView new];
    [scrollView addSubview:frame];
    frame.layer.borderColor = [UIColor redColor].CGColor;
    frame.layer.borderWidth = 2.0f;
    
    
    [frame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
    
    
    
    UISwitch *sw = [UISwitch new];
    [self.view addSubview:sw];
    [sw addTarget:self action:@selector(actionSwitch) forControlEvents:UIControlEventValueChanged];
}

- (void)actionSwitch
{
    self.scrollView.clipsToBounds = !self.scrollView.clipsToBounds;
}


@end
