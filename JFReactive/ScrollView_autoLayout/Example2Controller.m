//
//  Example2Controller.m
//  DemoScrollViewAutolayout
//
//  Created by Ralph Li on 12/1/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "Example2Controller.h"
#import <Masonry/Masonry.h>

@interface Example2Controller ()

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation Example2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //scrollView
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view).sizeOffset(CGSizeMake(-100,-300));
    }];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.clipsToBounds = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    
    //subviews
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor blueColor];
    containerView.alpha = 0.5;
    [scrollView addSubview:containerView];
    
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        
        make.size.equalTo(scrollView).sizeOffset(CGSizeMake(80, 80));
    }];
    
    
    //frame
    UIView *frame = [UIView new];
    [scrollView addSubview:frame];
    frame.layer.borderColor = [UIColor redColor].CGColor;
    frame.layer.borderWidth = 2.0f;
    [scrollView addSubview:frame];
    
    [frame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
    
    
    
    UISwitch *sw = [UISwitch new];
    [self.view addSubview:sw];
    [sw addTarget:self action:@selector(actionSwitch) forControlEvents:UIControlEventValueChanged];}

- (void)actionSwitch
{
    self.scrollView.clipsToBounds = !self.scrollView.clipsToBounds;
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

@end
