//
//  JFTransitionController.m
//  JFReactive
//
//  Created by Sun on 16/3/3.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "JFTransitionController.h"
#import <UIKit/UIKit.h>
#import "RotationPresentAnimation.h"
#import "JFPresentController.h"
#import "PanInteractiveTransition.h"
#import "JFPercentageAnimation.h"
@interface JFTransitionController()<UIViewControllerTransitioningDelegate>
//@property (nonatomic,strong)RotationPresentAnimation * presentAnimation;
@property (nonatomic,strong)JFPercentageAnimation * dismissAnimation;
@property (nonatomic,strong)JFPresentController * presentedVC;
@property (nonatomic,strong)PanInteractiveTransition * panTransition;
@end



@implementation JFTransitionController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   // self.presentAnimation = [[RotationPresentAnimation alloc] init];
    self.presentedVC = [[JFPresentController alloc] init];
    self.presentedVC.transitioningDelegate = self;
    
    //2
    self.panTransition = [[PanInteractiveTransition alloc] init];
    [self.panTransition panToDismiss:self.presentedVC];
    
    self.dismissAnimation = [[JFPercentageAnimation alloc] init];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(100, 100, 60, 40)];
    [btn setTitle:@"present" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(show ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)show{
    [self presentViewController:self.presentedVC animated:YES completion:^{
        
    }];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    return self.dismissAnimation ;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    // 会崩溃 需要处理
    //return self.presentAnimation;
   // if(self.panTransition conformsToProtocol:<#(Protocol *)#>)
    return (id<UIViewControllerAnimatedTransitioning>) self.panTransition;
}
@end
