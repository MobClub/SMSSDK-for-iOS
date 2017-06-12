//
//  MobSDK_Private.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 17/3/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <MOBFoundation/MOBFoundation.h>

@interface MobSDK ()

/**
 获取设备ID

 @return 设备ID
 */
+ (NSString *)duid;

/**
 *  必须使用带有IDFA的框架，此方法用于使依赖的上层框架必须使用带有IDFA的基础库，否则会由于没有该方法而导致编译报错。
 *  上层框架初始化时调用一次即可。
 */
+ (void)mustBeUsedFrameworkWithIdfa;

/**
 用户标识信息，用于请求时带给服务器，该信息包含应用相关信息以及SDK相关信息,格式如下：
 [APPPKG]/[APPVER] ([SDK_TYPE]/[SDK_VERSION])+ [SYSTEM_NAME]/[SYSTEM_VERSION] [TIME_ZONE] Lang/[LANG]
 
 @return 用户标识信息
 */
+ (NSString *)userIdentity;

@end
