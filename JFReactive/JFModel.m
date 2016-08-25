//
//  JFModel.m
//  JFReactive
//
//  Created by Sun on 15/12/26.
//  Copyright © 2015年 Sun. All rights reserved.
//

#import "JFModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@implementation JFModel



- (NSInteger)age{
    if (_age <= 0) {
        __block NSTimeInterval diffSecond = 10;
        NSLog(@"zheli .....");
        if ( diffSecond > 0) {
            NSTimeInterval cutDownTimes = diffSecond;
            
            [[[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]]take:cutDownTimes]subscribeNext:^(id x) {
                
                //            int seconds = (int) diffSecond % 60;
                //            int minutes = (int) (diffSecond / 60) % 60;
                //            int hours = (int) diffSecond / 3600;
                //            se
                [self setAge:diffSecond];
                
                NSLog(@"age ======= %ld",(long)_age);
                diffSecond -- ;
                
            }];
        }
    }
   

    return _age;
}
@end
