//
//  PanInteractiveTransition.m
//  JFReactive
//
//  Created by Sun on 16/3/3.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "PanInteractiveTransition.h"
@interface PanInteractiveTransition()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIViewController *presentedVC;
@end
@implementation PanInteractiveTransition


- (void)panToDismiss:(UIViewController *)VC{
    self.presentedVC = VC;
    UIPanGestureRecognizer *panGstR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.presentedVC.view addGestureRecognizer:panGstR];
}
- (void)panGestureAction:(UIPanGestureRecognizer*)gesture{
    CGPoint translationPoint = [gesture locationInView:self.presentedVC.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percentage = translationPoint.y / 300 >= 1? translationPoint.y /300 : 1;
            [self updateInteractiveTransition:percentage];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self finishInteractiveTransition];
            break;
        }case UIGestureRecognizerStateCancelled:{
            [self cancelInteractiveTransition];
            break;
        }
        default:
            break;
    }
}
@end
