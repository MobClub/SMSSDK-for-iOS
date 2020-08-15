//
//  SMSGlobalManager.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/8.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSGlobalManager.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+ContactFriends.h>
#import <MOBFoundation/MOBFoundation.h>

@interface SMSGlobalManager()

@property (nonatomic, strong)SMSSDKUserInfo *curUserInfo;
@end

@implementation SMSGlobalManager

+ (id)sharedManager
{
    static id _instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)init
{
    if (self = [super init])
    {

    }
    
    return self;
}

- (void)saveUserInfo:(NSString *)phone zone:(NSString *)zone
{
    
}

- (void)saveUserInfo
{
    
  
}


- (SMSSDKUserInfo *)copyUserInfo
{
    SMSSDKUserInfo *userInfo = [SMSSDKUserInfo new];
    
    userInfo.phone = _curUserInfo.phone;
    userInfo.zone = _curUserInfo.zone;
    userInfo.avatar = _curUserInfo.avatar;
    userInfo.nickname = _curUserInfo.nickname;
    userInfo.uid = _curUserInfo.uid;
    
    return userInfo;
}
@end
