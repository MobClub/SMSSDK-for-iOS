//
//  MOBFUser_Private.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/3/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

@interface MOBFUser ()

/**
 用户标识
 */
@property (nonatomic, copy) NSString *uid;

/**
 创建匿名用户信息
 
 @return 用户信息
 */
+ (MOBFUser *)anonymousUser;

@end
