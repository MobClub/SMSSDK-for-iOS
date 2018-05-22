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
        _curUserInfo = [[SMSSDKUserInfo alloc] init];
        
        
        NSDictionary *userInfoDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDict"];
        if(userInfoDict)
        {
            if(userInfoDict[@"phone"])
            {
                NSString *encodeStr = userInfoDict[@"phone"];
                NSData *data = [MOBFString dataByBase64DecodeString:encodeStr];
                if(data)
                {
                    NSString *phoneStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    _curUserInfo.phone = phoneStr;
                }

            }
            _curUserInfo.zone = userInfoDict[@"zone"];
            _curUserInfo.avatar = userInfoDict[@"avatar"];
            _curUserInfo.nickname = userInfoDict[@"nickname"];
            _curUserInfo.uid = userInfoDict[@"uid"];
        }


    }
    
    return self;
}

- (void)saveUserInfo:(NSString *)phone zone:(NSString *)zone
{
    if(!phone || !zone)
    {
        return;
    }
    
    if((self.curUserInfo && self.curUserInfo.phone && [self.curUserInfo.phone isEqualToString:phone]) && (self.curUserInfo && self.curUserInfo.zone && [self.curUserInfo.zone isEqualToString:zone]))
    {
        self.curUserInfo.phone = phone;
        self.curUserInfo.zone = zone;
    }
    else
    {
        self.curUserInfo = [[SMSSDKUserInfo alloc] init];
        self.curUserInfo.phone = phone;
        self.curUserInfo.zone = zone;
        self.curUserInfo.uid = [MOBFString md5String:self.curUserInfo.phone];
    }
    
    [self saveUserInfo];
}

- (void)saveUserInfo
{
    
    
    NSMutableDictionary *userInfoDict = [NSMutableDictionary new];
    
    
    if(self.curUserInfo.phone)
    {
        NSString *encodeStr = [MOBFData stringByBase64EncodeData:[self.curUserInfo.phone dataUsingEncoding:NSUTF8StringEncoding]];
        if(encodeStr)
            [userInfoDict setObject:encodeStr forKey:@"phone"];
    }
    else
    {
        [userInfoDict removeObjectForKey:@"phone"];
    }
    
    if(self.curUserInfo.zone)
    {
        [userInfoDict setObject:self.curUserInfo.zone forKey:@"zone"];
    }
    else
    {
        [userInfoDict removeObjectForKey:@"zone"];
    }
    
    if(self.curUserInfo.avatar)
    {
        [userInfoDict setObject:self.curUserInfo.avatar forKey:@"avatar"];
        
    }
    else
    {
        [userInfoDict removeObjectForKey:@"avatar"];
    }
    
    if(self.curUserInfo.nickname)
    {
        [userInfoDict setObject:self.curUserInfo.nickname forKey:@"nickname"];
        
    }
    else
    {
        [userInfoDict removeObjectForKey:@"nickname"];
    }
    
    if(self.curUserInfo.uid)
    {
        [userInfoDict setObject:self.curUserInfo.uid forKey:@"uid"];
        
    }
    else if(self.curUserInfo.phone)
    {
        [userInfoDict setObject:[MOBFString md5String:self.curUserInfo.phone] forKey:@"uid"];
    }
    else
    {
        [userInfoDict removeObjectForKey:@"uid"];
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfoDict forKey:@"userInfoDict"];
    
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
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
