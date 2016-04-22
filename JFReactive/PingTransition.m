//
//  PingTransition.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "PingTransition.h"
#import "ScaleTOneController.h"
#import "ScaleTranViewController.h"

@interface PingTransition ()
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation PingTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  5.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;

    ScaleTOneController * fromVC = (ScaleTOneController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ScaleTranViewController *toVC = (ScaleTranViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contView = [transitionContext containerView];

    UIButton *button = fromVC.button;
    
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:button.frame];    
   
    [contView addSubview:toVC.view];

    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    CGPoint finalPoint;
    //判断触发点在那个象限
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    // redius =  553
    NSLog(@"frame = %@",NSStringFromCGRect(button.frame));
    NSLog(@"inserRect = %@",NSStringFromCGRect(CGRectInset(button.frame, -radius, -radius)));
    /*
     注意inset的计算结果
     A rectangle. The origin value is offset in the x-axis by the distance specified by the dx parameter and in the y-axis by the distance specified by the dy parameter, and its size adjusted by (2*dx,2*dy), relative to the source rectangle. If dx and dy are positive values, then the rectangle’s size is decreased. If dx and dy are negative values, the rectangle’s size is increased.
     
     size 增加2*dx 2*dy   如果dx dy 为正值 则size 减小 反之 增加
      frame = {{321, 180}, {48, 48}}
      inserRect = {{-232.637, -373.637}, {1155.27, 1155.274}}
     */
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
   //The path defining the shape to be rendered. Animatable. path定义了layer的形状
    maskLayer.path = maskFinalBP.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    //
    /**
     *  ***********************
     */
    toVC.view.layer.mask = maskLayer;
    
    /**
     *  ***********************
     以一般的mask作说明（mask的值为1和0）。当一幅图作为mask的时候，你可以把它想象成一张不透明的带孔的纸，孔为1，其它部分为0，从数据来讲就是就是以1和0组成的矩阵。以这个矩阵和要被mask的图做数乘，可想而知，和mask中1相乘的保留了原来的值，而和0相乘的就变为0了。这样一来，就只保留了你想要的区域。
     根据以上原理，用A去maskB和用B去maskA就是不一样的。前者保留的是被Amask后的B的信号，而后者反之。
     当然，mask也不一定都为1或0，还可以是其它的数值，这取决于插值的方法和阈值等。原理还是矩阵间的点乘。至于交集并集什么的，只是更具需要做图形上的选取而已。
     
     
     不透明部分保留 透明部分不显示
     */
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}

#pragma mark - CABasicAnimation的Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
