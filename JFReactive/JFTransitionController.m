//
//  JFTransitionController.m
//  JFReactive
//
//  Created by Sun on 16/3/3.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "JFTransitionController.h"
#import <UIKit/UIKit.h>
#import "BouncePresentAnimation.h"
#import "JFPresentController.h"
#import "SwipeUpInteractiveTransition.h"
#import "NormalDismissAnimation.h"
@interface JFTransitionController()<UIViewControllerTransitioningDelegate>
//@property (nonatomic,strong)RotationPresentAnimation * presentAnimation;
@property (nonatomic,strong)NormalDismissAnimation * dismissAnimation;
@property (nonatomic,strong)JFPresentController * presentedVC;
@property (nonatomic,strong)BouncePresentAnimation * presentAnimation;
@property (nonatomic, strong) SwipeUpInteractiveTransition *transitionController;

@end



@implementation JFTransitionController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   // self.presentAnimation = [[RotationPresentAnimation alloc] init];
    self.presentedVC = [[JFPresentController alloc] init];
    self.presentedVC.transitioningDelegate = self;
    
    _presentAnimation = [BouncePresentAnimation new];
    _dismissAnimation = [NormalDismissAnimation new];
    _transitionController = [SwipeUpInteractiveTransition new];
    
   
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(100, 100, 60, 40)];
    [btn setTitle:@"present" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(show ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)show{
    NSLog(@"%@",self.navigationController.viewControllers);
     [self.transitionController wireToViewController:self.presentedVC];
    [self.navigationController pushViewController:self.presentedVC animated:YES];
//    [self presentViewController:self.presentedVC animated:YES completion:^{
//        
//    }];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    return self.dismissAnimation ;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    // 会崩溃 需要处理
    return self.presentAnimation;
}
-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}
@end
