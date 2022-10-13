//
//  SMSUserManager.h
//  SMSSDKUI
//
//  Created by hower on 2018/3/8.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSUserManager : NSObject

@property (nonatomic, strong, readonly)SMSSDKUserInfo *curUserInfo;


+ (id)sharedManager;

- (void)saveUserInfo:(NSString *)phone zone:(NSString *)zone;

- (void)save;
@end
