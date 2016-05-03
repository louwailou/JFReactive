//
//  GitUser.h
//  JFReactive
//
//  Created by Sun on 16/4/28.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GitUser : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *login;
@property (nonatomic,copy) NSString * userCode;
@end
