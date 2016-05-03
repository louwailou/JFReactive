//
//  GitUser.m
//  JFReactive
//
//  Created by Sun on 16/4/28.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "GitUser.h"

@implementation GitUser
+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{@"login":@"login",
             @"userCode":@"user_code"
             };
}
@end
